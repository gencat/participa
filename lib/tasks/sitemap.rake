# frozen_string_literal: true

namespace :sitemap do
  desc "Generate sitemaps, purge stale files, and update robots.txt"
  task generate: :environment do
    unless Rails.env.production?
      puts "Sitemap generation is intended for production environments only. Aborting."
      exit(-1)
    end

    sitemaps_dir = Rails.public_path.join("sitemaps")

    # ── Step 1: Generate ────────────────────────────────────────────────────
    generation_started_at = Time.current

    SitemapGenerator::Sitemap.verbose = true
    load Rails.root.join("config", "sitemap.rb")

    # ── Step 2: Purge stale files ────────────────────────────────────────────
    # Any sitemap file whose mtime predates this run was produced by a previous
    # generation and is no longer valid (e.g. a group that produced N numbered
    # files before now only produces N-1).
    stale = Dir.glob(sitemaps_dir.join("*.xml.gz")).select do |file|
      File.mtime(file) < generation_started_at
    end

    stale.each do |file|
      File.delete(file)
      puts "Removed stale sitemap: #{File.basename(file)}"
    end

    # ── Step 3: Rebuild robots.txt ───────────────────────────────────────────
    organization = Decidim::Organization.first
    host = "https://#{organization.host}"

    new_sitemap_files = Dir.glob(sitemaps_dir.join("*.xml.gz"))
    sitemap_directives = new_sitemap_files.map do |file|
      "Sitemap: #{host}/sitemaps/#{File.basename(file)}"
    end

    robots_path = Rails.public_path.join("robots.txt")
    current_content = File.read(robots_path)

    # Strip any existing Sitemap: lines (including the trailing newline of each)
    cleaned_content = current_content.gsub(/^Sitemap:.*\n?/, "").rstrip

    new_content = "#{cleaned_content}\n\n#{sitemap_directives.join("\n")}\n"
    File.write(robots_path, new_content)

    puts "robots.txt updated with #{sitemap_directives.size} Sitemap directives."
  end
end
