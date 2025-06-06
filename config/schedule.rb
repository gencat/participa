# frozen_string_literal: true

env :PATH, ENV.fetch("PATH", nil)

every :sunday, at: "4:00 am" do
  rake "decidim:delete_data_portability_files"
end

every :sunday, at: "5:00 am" do
  rake "decidim:open_data:export"
end

every 1.day, at: "2:00 am" do
  rake "decidim:metrics:all"
end

every :sunday, at: "11:59 pm" do
  rake "open_data:participatory_processes:publish_to_socrata"
end

every 1.day, at: "3:00 am" do
  rake "tmp:clear"
end

every 5.minutes do
  rake "participatory_processes_phases:enqueue_change_active_step"
end

every 1.day, at: "4:00 am" do
  rake "decidim:reminders:all"
end
