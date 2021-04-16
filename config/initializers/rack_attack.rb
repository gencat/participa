# frozen_string_literal: true

# unless %W[development test].include? Rails.env
Rack::Attack.throttle("requests by (forwarded) ip", limit: 30, period: 60) do |request|
  # x_forwarded_for= request.get_header('X-Forwarded-For')
  x_forwarded_for= request.get_header("HTTP_X_FORWARDED_FOR")
  Rails.logger.warn ">>>>>>>>>>>>>>>>>>>> X-Forwarded-For: #{x_forwarded_for}"
  if x_forwarded_for.present?
    ip= x_forwarded_for.split(":").first
    Rails.logger.warn ">>>>>>>>>>>>>>>>>>>> X-Forwarded-For IP: #{ip}"
    ip
  else
    request.ip
  end
end
# end

__END__
headers= []
request.each_header {|h| headers << h };nil
h= Hash[headers]
h.keys

puts "HEADER: #{h.class}"
request.each_header {|h| puts "HEADER: #{h.first}" };nil

request.env["HTTP_X_FORWARDED_FOR"]

curl -i -H "X-Forwarded-For: 95.169.225.62:51586" http://localhost:3000