env :PATH, ENV['PATH']

every :sunday, at: '4:00 am' do
  rake "decidim:delete_data_portability_files"
end

every 1.day, at: '2:00 am' do
  rake "decidim:metrics:all"
end
