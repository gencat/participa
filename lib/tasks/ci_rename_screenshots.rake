# frozen_string_literal: true

SCREENSHOT_DIRECTORY = "/home/runner/work/participa/participa/tmp/screenshots"

namespace :ci do
  namespace :screenshots do
    task rename: :environment do
      Dir["#{SCREENSHOT_DIRECTORY}/*"].each do |filename|
        new_filename = filename.gsub(":", "").gsub(". .", ".")
        File.rename(filename, new_filename)
        puts "#{filename} was renamed to #{new_filename}"
      end
    end
  end
end
