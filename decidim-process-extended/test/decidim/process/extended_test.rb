# frozen_string_literal: true

require "test_helper"

class Decidim::Process::Extended::Test < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, Decidim::Process::Extended
  end
end
