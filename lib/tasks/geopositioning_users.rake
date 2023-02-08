# frozen_string_literal: true

require "csv"
require "ipaddr"

namespace :geopositioning_users do
  # This task extracts a csv file with the IPs of the users and their location.
  desc "Generate a CSV with the users IP information"
  task generate_csv: :environment do
    headers = %w(email IP IP_location last_sign_in)
    # VPN IP, blank or nils
    invalid_ips = ["10.2.1.52", "", nil]
    users_with_valid_ip = Decidim::User.where.not(last_sign_in_ip: invalid_ips)

    CSV.open("users_ip_locations.csv", "w") do |csv|
      csv << headers

      users_with_valid_ip.each_with_index do |user, index|
        user_ip = user.last_sign_in_ip
        puts "User #{index}/#{users_with_valid_ip.count}"

        if IPAddr.new(user_ip).private?
          csv << [user.email, user_ip, "Private IP", user.last_sign_in_at]
        else
          # Delay to wait between requests to Geocoder API
          sleep 0.5
          csv << [user.email, user_ip, ip_location(user_ip), user.last_sign_in_at]
        end
      end
    end
  end

  private

  def ip_location(ip)
    results = Geocoder.search(ip).first

    results.present? ? results.address : nil
  end
end
