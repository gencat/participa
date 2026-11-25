# frozen_string_literal: true

require "hexapdf"
require "json"
require_relative "policy"

path, limits = ARGV
begin
  result = PdfSecurity::Policy.new(path, JSON.parse(limits)).inspect
rescue StandardError
  result = { status: "uninspectable", reasons: ["internal_error"], signed: false }
end
$stdout.write(JSON.generate(result))
