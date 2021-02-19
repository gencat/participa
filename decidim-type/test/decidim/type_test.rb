# frozen_string_literal: true

require "test_helper"

class Decidim::Type::Test < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, Decidim::Type
  end
end
