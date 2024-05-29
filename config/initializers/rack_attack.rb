# frozen_string_literal: true

unless ENV["CDTB_RACK_ATTACK_DISABLED"].to_i.positive? || %w(development test).include?(Rails.env)
  require "rack/attack"

  def extract_ip(request)
    x_forwarded_for= request.get_header("HTTP_X_FORWARDED_FOR")
    Rails.logger.info { ">>>>>>>>>>>>>>>>>>>> X-Forwarded-For: #{x_forwarded_for}" }
    if x_forwarded_for.present?
      ip= x_forwarded_for.split(":").first
      ip
    else
      request.ip
    end
  end

  limit= ENV.fetch("RACK_ATTACK_THROTTLE_LIMIT", 30)
  period= ENV.fetch("RACK_ATTACK_THROTTLE_PERIOD", 60)
  Rails.logger.info("Configuring Rack::Attack.throttle with limit: #{limit}, period: #{period}")
  Rack::Attack.throttle("requests by ip", limit: limit.to_i, period: period.to_i) do |request|
    # ignore requests to assets
    next if request.path.start_with?("/rails/active_storage")

    extract_ip(request)
  end

  limit= ENV.fetch("RACK_ATTACK_THROTTLE_RANGE_LIMIT", 10)
  period= ENV.fetch("RACK_ATTACK_THROTTLE_RANGE_PERIOD", 20)
  Rails.logger.info("Configuring Rack::Attack.throttle with limits for IP Ranges: #{limit}, period: #{period}")
  Rack::Attack.throttle("requests by ip range", limit: limit.to_i, period: period.to_i) do |request|
    # ignore requests to assets
    next if request.path.start_with?("/rails/active_storage")

    ip= extract_ip(request)
    # extract the 32bit range
    ip.split(".")[0, 2]
  end

  if ENV["RACK_ATTACK_BLOCKED_IPS"].present?
    ENV["RACK_ATTACK_BLOCKED_IPS"].split(",").each do |ip_or_subnet|
      Rack::Attack.blocklist_ip(ip_or_subnet)
    end
  end
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
