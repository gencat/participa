# frozen_string_literal: true

# This tasks are necessary to be executed on production
# because in a migration, the memory was owned.
namespace :proposals do
  desc "Move proposals fields to i18n: [:start_id, :end_id]"
  task :tmp_title, [:start_id, :end_id] => :environment do |_task, args|
    puts "processing [#{args.start_id}..#{args.end_id}["

    query = Decidim::Proposals::Proposal
    query = query.where("id <= ?", args.start_id.to_i) if args.start_id != "nil"
    query = query.where("id < ?", args.end_id.to_i)
    query.find_each do |proposal|
      author = proposal.coauthorships.first&.author

      locale = if author
                 author.try(:locale).presence || author.try(:default_locale).presence || author.try(:organization).try(:default_locale).presence
               elsif proposal.component && proposal.component.participatory_space
                 proposal.component.participatory_space.organization.default_locale
               else
                 I18n.default_locale.to_s
               end

      proposal.new_title = {
        locale => proposal.title
      }
      proposal.new_body = {
        locale => proposal.body
      }

      proposal.save(validate: false)
      print(".")
    end
    puts "\nApplying Garbage Collector"
    GC.start
  end
end
