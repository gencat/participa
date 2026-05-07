# frozen_string_literal: true

# ---------------------------------------------------------------------------
# Sitemap configuration for participa.gencat.cat
#
# Groups and their content:
#   processes      – participatory process landing pages + component pages
#   regulations    – /regulations index + regulation process + component pages
#   assemblies     – assembly landing pages + component pages
#   meetings       – individual meeting show pages (all spaces)
#   proposals      – individual proposal show pages (all spaces)
#   pages          – homepage, listing pages, static CMS pages
#   blogs          – individual blog post show pages (all spaces)
#   debates        – individual debate show pages (all spaces)
#   budgets        – individual budget project show pages (all spaces)
#   accountability – individual accountability result show pages (all spaces)
#   attachments    – PDF and image file blob URLs
#
# Generated files land in public/sitemaps/.
# The master index is public/sitemaps/sitemap.xml.gz.
# ---------------------------------------------------------------------------

# Make Rails route helpers (incl. rails_blob_path) available inside the
# create block and all group blocks.
SitemapGenerator::Interpreter.send(:include, Rails.application.routes.url_helpers)

# Helper: returns the URL prefix for a participatory space, or nil for
# space types that are not publicly routable.
SitemapGenerator::Interpreter.class_eval do
  def space_url_prefix(space)
    if space.is_a?(Decidim::ParticipatoryProcess)
      "/processes"
    elsif space.is_a?(Decidim::Assembly)
      "/assemblies"
    end
  end
end

organization = Decidim::Organization.first
host = "https://#{organization.host}"
regulation_group_id = Rails.application.config.regulation

SitemapGenerator::Sitemap.default_host = host
SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/"
SitemapGenerator::Sitemap.create_index = true
SitemapGenerator::Sitemap.compress = true
SitemapGenerator::Sitemap.include_root = false
SitemapGenerator::Sitemap.include_index = false

SitemapGenerator::Sitemap.create do
  # ── Participatory Processes (excluding regulations) ────────────────────────
  group(filename: :processes) do
    Decidim::ParticipatoryProcess
      .where(organization:)
      .published
      .where.not(decidim_participatory_process_group_id: regulation_group_id)
      .preload(:components)
      .find_each do |process|
        next if process.slug.blank?

        add "/processes/#{process.slug}",
            lastmod: process.updated_at, changefreq: "weekly", priority: 0.8

        process.components.select { |c| c.published_at.present? }.each do |component|
          add "/processes/#{process.slug}/f/#{component.id}",
              lastmod: component.updated_at, changefreq: "weekly", priority: 0.6
        end
      end
  end

  # ── Regulations ─────────────────────────────────────────────────────────────
  group(filename: :regulations) do
    add "/regulations", changefreq: "weekly", priority: 0.7

    Decidim::ParticipatoryProcess
      .where(organization:, decidim_participatory_process_group_id: regulation_group_id)
      .published
      .preload(:components)
      .find_each do |process|
        next if process.slug.blank?

        add "/processes/#{process.slug}",
            lastmod: process.updated_at, changefreq: "monthly", priority: 0.7

        process.components.select { |c| c.published_at.present? }.each do |component|
          add "/processes/#{process.slug}/f/#{component.id}",
              lastmod: component.updated_at, changefreq: "monthly", priority: 0.5
        end
      end
  end

  # ── Assemblies ──────────────────────────────────────────────────────────────
  group(filename: :assemblies) do
    Decidim::Assembly
      .where(organization:)
      .published
      .preload(:components)
      .find_each do |assembly|
        next if assembly.slug.blank?

        add "/assemblies/#{assembly.slug}",
            lastmod: assembly.updated_at, changefreq: "weekly", priority: 0.8

        assembly.components.select { |c| c.published_at.present? }.each do |component|
          add "/assemblies/#{assembly.slug}/f/#{component.id}",
              lastmod: component.updated_at, changefreq: "weekly", priority: 0.6
        end
      end
  end

  # ── Meetings ────────────────────────────────────────────────────────────────
  group(filename: :meetings) do
    Decidim::Meetings::Meeting
      .joins(:component)
      .where.not(decidim_components: { published_at: nil })
      .where.not(published_at: nil)
      .preload(component: :participatory_space)
      .find_each do |meeting|
        space = meeting.component.participatory_space
        prefix = space_url_prefix(space)
        next unless prefix && space&.slug.present?

        add "#{prefix}/#{space.slug}/f/#{meeting.component_id}/meetings/#{meeting.id}",
            lastmod: meeting.updated_at, changefreq: "weekly", priority: 0.5
      end
  end

  # ── Proposals ───────────────────────────────────────────────────────────────
  group(filename: :proposals) do
    Decidim::Proposals::Proposal
      .joins(:component)
      .where.not(decidim_components: { published_at: nil })
      .where.not(published_at: nil)
      .preload(component: :participatory_space)
      .find_each do |proposal|
        space = proposal.component.participatory_space
        prefix = space_url_prefix(space)
        next unless prefix && space&.slug.present?

        add "#{prefix}/#{space.slug}/f/#{proposal.component_id}/proposals/#{proposal.id}",
            lastmod: proposal.updated_at, changefreq: "monthly", priority: 0.5
      end
  end

  # ── Static Pages ────────────────────────────────────────────────────────────
  group(filename: :pages) do
    add "/", changefreq: "daily", priority: 1.0
    add "/processes", changefreq: "daily", priority: 0.7
    add "/assemblies", changefreq: "daily", priority: 0.7

    Decidim::StaticPage
      .where(organization:)
      .find_each do |page|
        add "/pages/#{page.slug}",
            lastmod: page.updated_at, changefreq: "monthly", priority: 0.4
      end
  end

  # ── Blog Posts ──────────────────────────────────────────────────────────────
  group(filename: :blogs) do
    Decidim::Blogs::Post
      .joins(:component)
      .where.not(decidim_components: { published_at: nil })
      .preload(component: :participatory_space)
      .find_each do |post|
        space = post.component.participatory_space
        prefix = space_url_prefix(space)
        next unless prefix && space&.slug.present?

        add "#{prefix}/#{space.slug}/f/#{post.component_id}/posts/#{post.id}",
            lastmod: post.updated_at, changefreq: "monthly", priority: 0.5
      end
  end

  # ── Debates ─────────────────────────────────────────────────────────────────
  group(filename: :debates) do
    Decidim::Debates::Debate
      .joins(:component)
      .where.not(decidim_components: { published_at: nil })
      .preload(component: :participatory_space)
      .find_each do |debate|
        space = debate.component.participatory_space
        prefix = space_url_prefix(space)
        next unless prefix && space&.slug.present?

        add "#{prefix}/#{space.slug}/f/#{debate.component_id}/debates/#{debate.id}",
            lastmod: debate.updated_at, changefreq: "weekly", priority: 0.5
      end
  end

  # ── Budget Projects ─────────────────────────────────────────────────────────
  group(filename: :budgets) do
    Decidim::Budgets::Project
      .joins(budget: :component)
      .where.not(decidim_components: { published_at: nil })
      .preload(budget: { component: :participatory_space })
      .find_each do |project|
        space = project.budget.component.participatory_space
        prefix = space_url_prefix(space)
        next unless prefix && space&.slug.present?

        add "#{prefix}/#{space.slug}/f/#{project.budget.component_id}" \
            "/budgets/#{project.budget_id}/projects/#{project.id}",
            lastmod: project.updated_at, changefreq: "monthly", priority: 0.4
      end
  end

  # ── Accountability Results ───────────────────────────────────────────────────
  group(filename: :accountability) do
    Decidim::Accountability::Result
      .joins(:component)
      .where.not(decidim_components: { published_at: nil })
      .preload(component: :participatory_space)
      .find_each do |result|
        space = result.component.participatory_space
        prefix = space_url_prefix(space)
        next unless prefix && space&.slug.present?

        add "#{prefix}/#{space.slug}/f/#{result.component_id}/results/#{result.id}",
            lastmod: result.updated_at, changefreq: "monthly", priority: 0.4
      end
  end

  # ── Attachments (PDFs and images) ───────────────────────────────────────────
  # Adds blob redirect URLs so search engines can index uploaded documents and
  # images.  The ActiveStorage redirect path is stable (the signed_id does not
  # expire).
  group(filename: :attachments) do
    Decidim::Attachment
      .where("content_type LIKE 'image/%' OR content_type = 'application/pdf'")
      .find_each do |attachment|
        next unless attachment.file.attached?

        blob_path = rails_blob_path(attachment.file, only_path: true)

        add blob_path,
            changefreq: "yearly",
            priority: attachment.content_type == "application/pdf" ? 0.4 : 0.3
      end
  end
end
