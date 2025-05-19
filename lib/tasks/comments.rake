# frozen_string_literal: true

namespace :comments do
  desc <<~EODESC
    Manages comments on closed participatory spaces. Supported arguments are:
    - cmd: One of
      - block_comments: Blocks comments on closed spaces.
      - list: Lists closed spaces.
    - published_state: Whether to filter spaces by published or not. Doesn't filter if blank.
  EODESC
  task :manage, [:cmd, :published_state] => :environment do |_task, args|
    cmd= args.cmd
    published_state= args.published_state

    # Key values are: { manifest_name => decidim_commentable_type }
    components= {
      accountability: Decidim::Accountability::Result,
      blogs: Decidim::Blogs::Post,
      budgets: Decidim::Budgets::Project,
      # challenges: nil,
      debates: Decidim::Debates::Debate,
      meetings: Decidim::Meetings::Meeting,
      # pages: nil,
      # problems: nil,
      proposals: Decidim::Proposals::Proposal
      # sdgs: nil,
      # solutions: nil,
      # sortitions: nil,
      # surveys: nil,
    }

    query= Decidim::ParticipatoryProcess
    if published_state.present?
      published_state= published_state == "true"
      puts "ONLY published? #{published_state}"
      query= if published_state
               query.where.not(published_at: nil)
             else
               query.where(published_at: nil)
             end
    end

    if cmd&.to_sym == :list
      puts "Listing participatory processes:"
      total_processes= query.count
      closed_processes= []
      undefined_state_processes= []
      open_processes= []
      query.find_each do |process|
        if process.active_step.nil? || process&.active_step&.end_date.nil?
          undefined_state_processes << process
        elsif process&.active_step&.end_date&.< Time.zone.today
          closed_processes << process
        else
          open_processes << process
        end
      end
      puts "\e[1m=> #{total_processes} processes\e[0m"
      puts "\e[1m=> #{closed_processes.size} closed processes\e[0m"
      closed_processes.each do |process|
        puts "- #{process.id}.#{process.slug}.#{process&.active_step&.end_date}.#{process.title[I18n.default_locale.to_s]}"
      end
      puts "\e[1m=> #{undefined_state_processes.size} undefined state processes, to be ignored.\e[0m"
      undefined_state_processes.each do |process|
        puts "- #{process.id}.#{process.slug}.#{process.title[I18n.default_locale.to_s]}"
      end
      puts "\e[1m=> #{open_processes.size} Open processes:\e[0m"
      open_processes.each do |process|
        puts "- #{process.id}.#{process.slug}.#{process.title[I18n.default_locale.to_s]}"
      end
      puts ""
    elsif cmd&.to_sym == :block_comments
      puts "Going to block participatory processes:"
      query.find_each do |process|
        if process.id == 752
          puts "PROCESS 752 IS AN EXCEPTION"
          next
        end

        if process.active_step.nil? || process&.active_step&.end_date.nil?
          puts "- IGNORING   : #{process.id}.#{process.slug}.#{process.title[I18n.default_locale.to_s]}"
        elsif process&.active_step&.end_date&.< Time.zone.today
          print "- BLOCK_COMMS.: #{process.id}.#{process.slug}.#{process&.active_step&.end_date}.#{process.title[I18n.default_locale.to_s]}"
          commentable_components= process.components.where(manifest_name: components.keys)
          commentable_components.each do |component|
            component[:settings]["default_step"]= component.default_step_settings.to_h if component[:settings]["default_step"].blank?
            component[:settings]["default_step"]["comments_blocked"]= true
            print("[#{component.id}|default_step]")
            component.step_settings.each_pair do |step_id, _settings|
              component[:settings]["steps"][step_id.to_s]= component.default_step_settings.to_h if component[:settings].dig("steps", step_id.to_s).blank?
              component[:settings]["steps"][step_id.to_s]["comments_blocked"]= true
              print("[#{component.id}|#{step_id}]")
            end
            component.save(validate: false)
            puts("")
          end
        else
          puts "- OPEN       : #{process.id}.#{process.slug}.#{process.title[I18n.default_locale.to_s]}"
        end
      end
    else
      puts "Unknow param: #{param}"
      exit(-1)
    end
  end
end
