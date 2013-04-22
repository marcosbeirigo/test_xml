require 'test_xml/matcher_methods'
require 'ostruct'

module TestXml
  class AssertionConfig < OpenStruct
    def assert_name
      "assert_#{name}"
    end

    def assert_not_name
      "assert_not_#{name}"
    end
  end

  ASSERTIONS = [
    AssertionConfig.new(
      :name       => :xml_contain,
      :matcher    => :must_contain_xml,
      :message_for_should     => lambda { |a,b| "the xml:\n#{a}\nshould contain xml:\n#{b}" },
      :message_for_should_not => lambda { |a,b| "the xml:\n#{a}\nshould not contain xml:\n#{b} but it does" }
    ),
    AssertionConfig.new(
      :name       => :xml_structure_contain,
      :matcher    => :must_contain_xml_structure,
      :message_for_should     => lambda { |a,b| "the xml:\n#{a}\nshould match xml structure:\n#{b}" },
      :message_for_should_not => lambda { |a,b| "the xml:\n#{a}\nshould not match xml structure:\n#{b} but it does" }
    ),
    AssertionConfig.new(
      :name       => :xml_equal,
      :matcher    => :must_equal_xml,
      :message_for_should     => lambda { |a,b| "the xml:\n#{a}\nshould exactly match xml:\n#{b}" },
      :message_for_should_not => lambda { |a,b| "the xml:\n#{a}\nshould not exactly match xml:\n#{b} but it does" }
    ),
    AssertionConfig.new(
      :name       => :xml_structure_equal,
      :matcher    => :must_equal_xml_structure,
      :message_for_should     => lambda { |a,b| "the xml:\n#{a}\nshould exactly match xml structure:\n#{b}" },
      :message_for_should_not => lambda { |a,b| "the xml:\n#{a}\nshould not exactly match xml structure:\n#{b} but it does" }
    )
  ]

  module TestUnit
    module Assertions
      ASSERTIONS.each do |cfg|
        define_method(cfg.assert_name) do |a, b|
          correct_assert(MatcherMethods.send(cfg.name, a, b), cfg.message_for_should.call(a, b))
        end

        define_method(cfg.assert_not_name) do |a, b|
          correct_assert(! MatcherMethods.send(cfg.name, a, b), cfg.message_for_should_not.call(a, b))
        end
      end

    private
      def correct_assert(boolean, message)
        if RUBY_VERSION =~ /1.9.2/ or defined?(MiniTest)
          assert(boolean, message)
        else
          assert_block(message) do
            boolean
          end
        end
      end
    end
  end
end
