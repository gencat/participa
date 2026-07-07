# frozen_string_literal: true

require "rails_helper"

describe "sitemap:generate rake task" do
  subject(:task) { Rake::Task["sitemap:generate"] }

  before do
    Rails.application.load_tasks unless Rake::Task.task_defined?("sitemap:generate")
    task.reenable
  end

  # ── Production guard ────────────────────────────────────────────────────────

  describe "production guard" do
    before { allow(Rails.env).to receive(:production?).and_return(false) }

    it "exits when not running in production" do
      expect { task.invoke }.to raise_error(SystemExit)
    end
  end

  # ── Production behaviour ────────────────────────────────────────────────────

  context "when running in production" do
    let!(:organization) { create(:organization) }
    let(:tmpdir) { Pathname.new(Dir.mktmpdir) }

    # rspec-mocks stubs must be set up in before/it/after, not in around.
    before do
      allow(Rails.env).to receive(:production?).and_return(true)
      allow(Rails).to receive(:public_path).and_return(tmpdir)
    end

    # File-system isolation and SitemapGenerator state go in around so that
    # cleanup runs even when an example raises.
    around do |example|
      orig_public_path = SitemapGenerator::Sitemap.public_path
      orig_verbose = SitemapGenerator::Sitemap.verbose

      FileUtils.mkdir_p(tmpdir.join("sitemaps"))
      File.write(tmpdir.join("robots.txt"), initial_robots_txt)

      SitemapGenerator::Sitemap.public_path = tmpdir
      SitemapGenerator::Sitemap.verbose = false

      example.run
    ensure
      FileUtils.rm_rf(tmpdir)
      SitemapGenerator::Sitemap.public_path = orig_public_path
      SitemapGenerator::Sitemap.verbose = orig_verbose
    end

    let(:initial_robots_txt) do
      <<~ROBOTS
        # See http://www.robotstxt.org/robotstxt.html

        User-agent: *
        Disallow: /admin/
        Allow: /processes/
        Sitemap: https://participa.gencat.cat/sitemaps/old_sitemap.xml.gz
      ROBOTS
    end

    # ── Stale file purge ──────────────────────────────────────────────────────

    describe "stale file cleanup" do
      let(:stale_path) { tmpdir.join("sitemaps", "stale_processes.xml.gz") }

      before do
        # Create a file that predates the generation run.
        # File.utime requires Integer/Float timestamps in Ruby 3.1+.
        FileUtils.touch(stale_path)
        File.utime(1.hour.ago.to_i, 1.hour.ago.to_i, stale_path)
      end

      it "removes sitemap files that predate the current generation run" do
        task.invoke
        expect(File.exist?(stale_path)).to be false
      end

      it "keeps sitemap files that were written during the current generation run" do
        task.invoke
        fresh_files = Dir.glob(tmpdir.join("sitemaps", "*.xml.gz"))
        expect(fresh_files).not_to be_empty
      end
    end

    # ── robots.txt update ─────────────────────────────────────────────────────

    describe "robots.txt update" do
      before { task.invoke }

      let(:robots_content) { File.read(tmpdir.join("robots.txt")) }

      it "removes stale Sitemap: lines from the previous run" do
        expect(robots_content).not_to include("old_sitemap.xml.gz")
      end

      it "adds a Sitemap: directive for every generated file" do
        generated = Dir.glob(tmpdir.join("sitemaps", "*.xml.gz")).map { |f| File.basename(f) }
        expect(generated).not_to be_empty

        generated.each do |filename|
          expect(robots_content).to include("Sitemap: https://#{organization.host}/sitemaps/#{filename}")
        end
      end

      it "preserves User-agent rules" do
        expect(robots_content).to include("User-agent: *")
        expect(robots_content).to include("Disallow: /admin/")
        expect(robots_content).to include("Allow: /processes/")
      end

      it "does not duplicate Sitemap: entries when run multiple times" do
        task.reenable
        task.invoke

        sitemap_lines = File.readlines(tmpdir.join("robots.txt"))
                            .select { |l| l.start_with?("Sitemap:") }
        expect(sitemap_lines.uniq).to eq(sitemap_lines)
      end
    end
  end
end
