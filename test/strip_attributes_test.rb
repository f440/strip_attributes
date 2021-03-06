#-coding: utf-8 -*-
require "test_helper"

module MockAttributes
  def self.included(base)
    base.attributes :foo, :bar, :biz, :baz, :bang, :bop
  end
end

class StripAllMockRecord < Tableless
  include MockAttributes
  strip_attributes
end

class StripOnlyOneMockRecord < Tableless
  include MockAttributes
  strip_attributes :only => :foo
end

class StripOnlyThreeMockRecord < Tableless
  include MockAttributes
  strip_attributes :only => [:foo, :bar, :biz]
end

class StripExceptOneMockRecord < Tableless
  include MockAttributes
  strip_attributes :except => :foo
end

class StripExceptThreeMockRecord < Tableless
  include MockAttributes
  strip_attributes :except => [:foo, :bar, :biz]
end

class StripButAllowBlankMockRecord < Tableless
  include MockAttributes
  strip_attributes :allow_blank => true
end

class StripButAllowBlankAndExceptOneMockRecord < Tableless
  include MockAttributes
  strip_attributes :except => :foo, :allow_blank => true
end

class StripButAllowBlankAndOnlyOneMockRecord < Tableless
  include MockAttributes
  strip_attributes :only => :baz, :allow_blank => true
end

class StripAttributesTest < Test::Unit::TestCase
  def setup
    @init_params = { :foo => "\tfoo", :bar => "bar \t ", :biz => "\tbiz ", :baz => "", :bang => " ", :bop => "　" }
  end

  def test_should_exist
    assert Object.const_defined?(:StripAttributes)
  end

  def test_should_strip_all_fields
    record = StripAllMockRecord.new(@init_params)
    record.valid?
    assert_equal "foo", record.foo
    assert_equal "bar", record.bar
    assert_equal "biz", record.biz
    assert_nil record.baz
    assert_nil record.bang
    assert_nil record.bop
  end

  def test_should_strip_only_one_field
    record = StripOnlyOneMockRecord.new(@init_params)
    record.valid?
    assert_equal "foo",     record.foo
    assert_equal "bar \t ", record.bar
    assert_equal "\tbiz ",  record.biz
    assert_equal "",        record.baz
    assert_equal " ",       record.bang
    assert_equal "　",       record.bop
  end

  def test_should_strip_only_three_fields
    record = StripOnlyThreeMockRecord.new(@init_params)
    record.valid?
    assert_equal "foo", record.foo
    assert_equal "bar", record.bar
    assert_equal "biz", record.biz
    assert_equal "",    record.baz
    assert_equal " ",   record.bang
    assert_equal "　",   record.bop
  end

  def test_should_strip_all_except_one_field
    record = StripExceptOneMockRecord.new(@init_params)
    record.valid?
    assert_equal "\tfoo", record.foo
    assert_equal "bar",   record.bar
    assert_equal "biz",   record.biz
    assert_nil record.baz
    assert_nil record.bang
    assert_nil record.bop
  end

  def test_should_strip_all_except_three_fields
    record = StripExceptThreeMockRecord.new(@init_params)
    record.valid?
    assert_equal "\tfoo",   record.foo
    assert_equal "bar \t ", record.bar
    assert_equal "\tbiz ",  record.biz
    assert_nil record.baz
    assert_nil record.bang
    assert_nil record.bop
  end

  def test_should_allow_blank
    record = StripButAllowBlankMockRecord.new(@init_params)
    record.valid?
    assert_equal "foo", record.foo
    assert_equal "bar", record.bar
    assert_equal "biz", record.biz
    assert_equal "",    record.baz
    assert_equal "",   record.bang
    assert_equal "",   record.bop
  end

  def test_should_strip_only_one_field_and_allow_blank
    record = StripButAllowBlankAndOnlyOneMockRecord.new(@init_params)
    record.valid?
    assert_equal "\tfoo",     record.foo
    assert_equal "bar \t ", record.bar
    assert_equal "\tbiz ",  record.biz
    assert_equal "",        record.baz
    assert_equal " ",       record.bang
    assert_equal "　",       record.bop
  end

  def test_should_strip_all_except_one_field_and_allow_blank
    record = StripButAllowBlankAndExceptOneMockRecord.new(@init_params)
    record.valid?
    assert_equal "\tfoo", record.foo
    assert_equal "bar",   record.bar
    assert_equal "biz",   record.biz
    assert_equal "",    record.baz
    assert_equal "",   record.bang
    assert_equal "",   record.bop
  end
end
