#!/usr/bin/env ruby
# frozen_string_literal: true

# curl -i -H "Accept: application/json" -H "Content-Type: application/json" http://localhost:3000

require "socket"

server = TCPServer.new 3000
loop do
  Thread.start(server.accept) do |client|
    puts "Connection received:<"
    # puts client.readlines
    while (line = client.gets) # Read lines from socket
      puts line # and print them
    end
    # puts client.gets
    puts "> End of connection. Responding"
    client.puts "Hello !"
    client.puts "Time is #{Time.zone.now}"
    client.close
  end
end
