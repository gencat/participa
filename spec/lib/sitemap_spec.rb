# frozen_string_literal: true

require "rails_helper"
require "zlib"
require "uri"

describe "config/sitemap.rb" do
  let!(:organization) { create(:organization) }
  let(:tmpdir) { Pathname.new(Dir.mktmpdir) }

  # Save and restore SitemapGenerator state around each example so that the
  # global singleton does not leak settings between tests.
  around do |example|
    orig_public_path = SitemapGenerator::Sitemap.public_path
    orig_verbose = SitemapGenerator::Sitemap.verbose

    FileUtils.mkdir_p(tmpdir.join("sitemaps"))
    SitemapGenerator::Sitemap.public_path = tmpdir
    SitemapGenerator::Sitemap.verbose = false

    example.run
  ensure
    FileUtils.rm_rf(tmpdir)
    SitemapGenerator::Sitemap.public_path = orig_public_path
    SitemapGenerator::Sitemap.verbose = orig_verbose
  end

  # Loads config/sitemap.rb, which sets options on SitemapGenerator::Sitemap
  # and immediately runs SitemapGenerator::Sitemap.create, writing .xml.gz
  # files to tmpdir/sitemaps/.
  def generate_sitemap!
    load Rails.root.join("config", "sitemap.rb")
  end

  # Returns the path portion of every URL found across all non-index sitemap
  # files produced by the last generate_sitemap! call.
  def sitemap_paths
    Dir.glob(tmpdir.join("sitemaps", "*.xml.gz"))
       .reject { |f| File.basename(f) == "sitemap.xml.gz" }
       .flat_map do |path|
         xml = Zlib::GzipReader.open(path, &:read)
         Nokogiri::XML(xml)
                 .xpath("//sm:loc", "sm" => "http://www.sitemaps.org/schemas/sitemap/0.9")
                 .map { |node| URI.parse(node.text).path }
       end
  end

  # Returns the path portion of every URL found in a specific named sub-sitemap.
  # filename should be a Symbol or String matching the group filename (e.g. :processes).
  def sitemap_paths_for(filename)
    path = tmpdir.join("sitemaps", "#{filename}.xml.gz")
    return [] unless File.exist?(path)

    xml = Zlib::GzipReader.open(path, &:read)
    Nokogiri::XML(xml)
            .xpath("//sm:loc", "sm" => "http://www.sitemaps.org/schemas/sitemap/0.9")
            .map { |node| URI.parse(node.text).path }
  end

  # ── Participatory Processes ──────────────────────────────────────────────────

  describe "processes group" do
    let!(:process) { create(:participatory_process, :published, :with_steps, organization:) }
    let!(:published_component) { create(:component, :published, participatory_space: process) }
    let!(:unpublished_component) { create(:component, :unpublished, participatory_space: process) }
    let!(:unpublished_process) { create(:participatory_process, organization:, published_at: nil) }
    let!(:regulation_process) do
      create(:participatory_process, :published, :with_steps, organization:,
                                                              decidim_participatory_process_group_id: Rails.application.config.regulation)
    end

    before { generate_sitemap! }

    it "includes the published process landing page" do
      expect(sitemap_paths).to include("/processes/#{process.slug}")
    end

    it "includes published component pages for the process" do
      expect(sitemap_paths).to include("/processes/#{process.slug}/f/#{published_component.id}")
    end

    it "excludes unpublished component pages" do
      expect(sitemap_paths).not_to include("/processes/#{process.slug}/f/#{unpublished_component.id}")
    end

    it "excludes unpublished processes" do
      expect(sitemap_paths).not_to include("/processes/#{unpublished_process.slug}")
    end

    it "excludes regulation processes from the processes group" do
      expect(sitemap_paths_for(:processes)).not_to include("/processes/#{regulation_process.slug}")
    end
  end

  # ── Regulations ──────────────────────────────────────────────────────────────

  describe "regulations group" do
    let!(:regulation_process) do
      create(:participatory_process, :published, :with_steps, organization:,
                                                              decidim_participatory_process_group_id: Rails.application.config.regulation)
    end
    let!(:regulation_component) do
      create(:component, :published, participatory_space: regulation_process)
    end

    before { generate_sitemap! }

    it "includes the /regulations listing page" do
      expect(sitemap_paths).to include("/regulations")
    end

    it "includes the regulation process page" do
      expect(sitemap_paths).to include("/processes/#{regulation_process.slug}")
    end

    it "includes the regulation process component page" do
      expect(sitemap_paths).to include("/processes/#{regulation_process.slug}/f/#{regulation_component.id}")
    end
  end

  # ── Assemblies ───────────────────────────────────────────────────────────────

  describe "assemblies group" do
    let!(:assembly) { create(:assembly, :published, organization:) }
    let!(:published_component) { create(:component, :published, participatory_space: assembly) }
    let!(:unpublished_assembly) { create(:assembly, :unpublished, organization:) }

    before { generate_sitemap! }

    it "includes the published assembly landing page" do
      expect(sitemap_paths).to include("/assemblies/#{assembly.slug}")
    end

    it "includes published component pages for the assembly" do
      expect(sitemap_paths).to include("/assemblies/#{assembly.slug}/f/#{published_component.id}")
    end

    it "excludes unpublished assemblies" do
      expect(sitemap_paths).not_to include("/assemblies/#{unpublished_assembly.slug}")
    end
  end

  # ── Meetings ─────────────────────────────────────────────────────────────────

  describe "meetings group" do
    let!(:process) { create(:participatory_process, :published, :with_steps, organization:) }
    let!(:meetings_component) { create(:meeting_component, :published, participatory_space: process) }
    let!(:meeting) { create(:meeting, :published, component: meetings_component) }
    let!(:unpublished_meetings_component) do
      create(:meeting_component, :unpublished, participatory_space: process)
    end
    let!(:meeting_in_unpublished_component) do
      create(:meeting, :published, component: unpublished_meetings_component)
    end

    before { generate_sitemap! }

    it "includes meetings from published components" do
      expect(sitemap_paths).to include(
        "/processes/#{process.slug}/f/#{meetings_component.id}/meetings/#{meeting.id}"
      )
    end

    it "excludes meetings from unpublished components" do
      expect(sitemap_paths).not_to include(
        "/processes/#{process.slug}/f/#{unpublished_meetings_component.id}/meetings/#{meeting_in_unpublished_component.id}"
      )
    end
  end

  # ── Proposals ────────────────────────────────────────────────────────────────

  describe "proposals group" do
    let!(:process) { create(:participatory_process, :published, :with_steps, organization:) }
    let!(:proposals_component) { create(:proposal_component, :published, participatory_space: process) }
    let!(:proposal) { create(:proposal, :published, component: proposals_component) }
    let!(:draft_proposal) { create(:proposal, :draft, component: proposals_component) }

    before { generate_sitemap! }

    it "includes published proposals" do
      expect(sitemap_paths).to include(
        "/processes/#{process.slug}/f/#{proposals_component.id}/proposals/#{proposal.id}"
      )
    end

    it "excludes draft (unpublished) proposals" do
      expect(sitemap_paths).not_to include(
        "/processes/#{process.slug}/f/#{proposals_component.id}/proposals/#{draft_proposal.id}"
      )
    end
  end

  # ── Static Pages ─────────────────────────────────────────────────────────────

  describe "pages group" do
    let!(:static_page) { create(:static_page, organization:) }

    before { generate_sitemap! }

    it "includes the root URL" do
      # SitemapGenerator normalises the root to the bare host (no trailing slash),
      # so URI.parse gives path "".  Accept both forms to be safe.
      expect(sitemap_paths & ["", "/"]).not_to be_empty
    end

    it "includes the processes listing" do
      expect(sitemap_paths).to include("/processes")
    end

    it "includes the assemblies listing" do
      expect(sitemap_paths).to include("/assemblies")
    end

    it "includes static CMS pages" do
      expect(sitemap_paths).to include("/pages/#{static_page.slug}")
    end
  end

  # ── Blog Posts ───────────────────────────────────────────────────────────────

  describe "blogs group" do
    let!(:process) { create(:participatory_process, :published, :with_steps, organization:) }
    let!(:post_component) { create(:post_component, :published, participatory_space: process) }
    let!(:post) { create(:post, component: post_component) }

    before { generate_sitemap! }

    it "includes published blog posts" do
      expect(sitemap_paths).to include(
        "/processes/#{process.slug}/f/#{post_component.id}/posts/#{post.id}"
      )
    end
  end

  # ── Debates ──────────────────────────────────────────────────────────────────

  describe "debates group" do
    let!(:process) { create(:participatory_process, :published, :with_steps, organization:) }
    let!(:debates_component) { create(:debates_component, :published, participatory_space: process) }
    let!(:debate) { create(:debate, component: debates_component) }

    before { generate_sitemap! }

    it "includes debates from published components" do
      expect(sitemap_paths).to include(
        "/processes/#{process.slug}/f/#{debates_component.id}/debates/#{debate.id}"
      )
    end
  end

  # ── Budget Projects ───────────────────────────────────────────────────────────

  describe "budgets group" do
    let!(:process) { create(:participatory_process, :published, :with_steps, organization:) }
    let!(:budgets_component) { create(:budgets_component, :published, participatory_space: process) }
    let!(:budget) { create(:budget, component: budgets_component) }
    let!(:project) { create(:project, budget:) }

    before { generate_sitemap! }

    it "includes budget projects from published components" do
      expect(sitemap_paths).to include(
        "/processes/#{process.slug}/f/#{budgets_component.id}/budgets/#{budget.id}/projects/#{project.id}"
      )
    end
  end

  # ── Accountability Results ────────────────────────────────────────────────────

  describe "accountability group" do
    let!(:process) { create(:participatory_process, :published, :with_steps, organization:) }
    let!(:accountability_component) do
      create(:accountability_component, :published, participatory_space: process)
    end
    let!(:result) { create(:result, component: accountability_component) }

    before { generate_sitemap! }

    it "includes accountability results from published components" do
      expect(sitemap_paths).to include(
        "/processes/#{process.slug}/f/#{accountability_component.id}/results/#{result.id}"
      )
    end
  end

  # ── Attachments ───────────────────────────────────────────────────────────────

  describe "attachments group" do
    let!(:process) { create(:participatory_process, :published, :with_steps, organization:) }

    context "with an image attachment" do
      let!(:attachment) do
        create(:attachment, attached_to: process, content_type: "image/jpeg")
      end

      before { generate_sitemap! }

      it "includes the ActiveStorage blob path for the image" do
        blob_path = Rails.application.routes.url_helpers.rails_blob_path(attachment.file, only_path: true)
        expect(sitemap_paths).to include(blob_path)
      end
    end

    context "with a PDF attachment" do
      let!(:attachment) do
        create(:attachment, attached_to: process,
                            content_type: "application/pdf",
                            file: Decidim::Dev.test_file("Exampledocument.pdf", "application/pdf"))
      end

      before { generate_sitemap! }

      it "includes the ActiveStorage blob path for the PDF" do
        blob_path = Rails.application.routes.url_helpers.rails_blob_path(attachment.file, only_path: true)
        expect(sitemap_paths).to include(blob_path)
      end
    end

    context "with a plain-text attachment" do
      let!(:other_attachment) do
        # Create an attachment with a non-image, non-PDF content type by directly
        # updating the column after creation (factory always creates images).
        att = create(:attachment, attached_to: process)
        att.update_column(:content_type, "text/plain") # rubocop:disable Rails/SkipsModelValidations
        att
      end

      before { generate_sitemap! }

      it "excludes non-image, non-PDF attachments" do
        blob_path = Rails.application.routes.url_helpers.rails_blob_path(other_attachment.file, only_path: true)
        expect(sitemap_paths).not_to include(blob_path)
      end
    end
  end

  # ── Sitemap index ─────────────────────────────────────────────────────────────

  describe "sitemap index" do
    before { generate_sitemap! }

    it "creates a sitemap index file" do
      expect(File.exist?(tmpdir.join("sitemaps", "sitemap.xml.gz"))).to be true
    end

    it "creates at least one sub-sitemap per content group" do
      sub_sitemaps = Dir.glob(tmpdir.join("sitemaps", "*.xml.gz"))
                        .reject { |f| File.basename(f) == "sitemap.xml.gz" }
      expect(sub_sitemaps.count).to be >= 1
    end

    it "index references all generated sub-sitemap files" do
      sub_sitemaps = Dir.glob(tmpdir.join("sitemaps", "*.xml.gz"))
                        .reject { |f| File.basename(f) == "sitemap.xml.gz" }
                        .map { |f| File.basename(f) }

      index_xml = Zlib::GzipReader.open(tmpdir.join("sitemaps", "sitemap.xml.gz"), &:read)
      index_locs = Nokogiri::XML(index_xml)
                           .xpath("//sm:loc", "sm" => "http://www.sitemaps.org/schemas/sitemap/0.9")
                           .map { |node| File.basename(node.text) }

      sub_sitemaps.each do |filename|
        expect(index_locs).to include(filename)
      end
    end
  end
end
