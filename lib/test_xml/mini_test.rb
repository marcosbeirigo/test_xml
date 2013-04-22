require "test_xml"
require 'test_xml/test_unit/assertions'

MiniTest::Unit::TestCase.class_eval do
  include TestXml::TestUnit::Assertions
end

# TODO: should we remove test_xml/spec?
MiniTest::Expectations.class_eval do
  TestXml::ASSERTIONS.each do |cfg|
    infect_an_assertion(cfg.assert_name, cfg.matcher)
  end
end