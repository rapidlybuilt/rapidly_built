require "test_helper"

module RapidlyBuilt
  module Toolkit
    module Request
      class ContextTest < ActiveSupport::TestCase
        setup do
          @toolkit = Toolkit::Base.new

          # Create stub objects
          @cookies = Object.new

          @request = Object.new
          @request.define_singleton_method(:cookies) { nil }  # Define method first
          Spy.on(@request, :cookies).and_return(@cookies)  # Then spy on it

          @controller = Object.new
          @controller.define_singleton_method(:request) { nil }  # Define method first
          Spy.on(@controller, :request).and_return(@request)  # Then spy on it

          @context = Context.new(
            toolkit: @toolkit,
            ui: Object.new,
            controller: @controller,
          )
        end

        test "delegates cookies to the controller" do
          assert_equal @cookies, @context.cookies
        end
      end
    end
  end
end
