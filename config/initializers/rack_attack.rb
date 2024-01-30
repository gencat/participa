# frozen_string_literal: true

unless %w(development test).include? Rails.env
  require "rack/attack"

  limit= ENV["RACK_ATTACK_THROTTLE_LIMIT"] || 30
  period= ENV["RACK_ATTACK_THROTTLE_PERIOD"] || 60
  Rails.logger.info("Configuring Rack::Attack.throttle with limit: #{limit}, period: #{period}")
  Rack::Attack.throttle("requests by (forwarded) ip", limit: limit.to_i, period: period.to_i) do |request|
    # ignore requests to assets
    next if request.path.start_with?("/rails/active_storage")

    # x_forwarded_for= request.get_header('X-Forwarded-For')
    x_forwarded_for= request.get_header("HTTP_X_FORWARDED_FOR")
    Rails.logger.debug { ">>>>>>>>>>>>>>>>>>>> X-Forwarded-For: #{x_forwarded_for}" }
    if x_forwarded_for.present?
      ip= x_forwarded_for.split(":").first
      Rails.logger.info { ">>>>>>>>>>>>>>>>>>>> X-Forwarded-For IP: #{ip}" }
      ip
    else
      request.ip
    end
  end

  Rack::Attack.blocklist_ip(ENV["RACK_ATTACK_BLOCKED_IPS"].split(",")) if ENV["RACK_ATTACK_BLOCKED_IPS"].present?
end

__END__
headers= []
request.each_header {|h| headers << h };nil
h= Hash[headers]
h.keys

puts "HEADER: #{h.class}"
request.each_header {|h| puts "HEADER: #{h.first}" };nil

request.env["HTTP_X_FORWARDED_FOR"]

curl -i -H "X-Forwarded-For: 95.169.225.62:51586" http://localhost:3000
