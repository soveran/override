require 'test/unit'
require 'rubygems'
require 'shoulda'

require File.dirname(__FILE__) + "/../lib/override"

class Foo
  def bar
    "Bar"
  end

  def baz
    yield "Baz"
  end

  def qux a, b, c
    "Qux"
  end

  def == other
    bar == other.bar
  end
end

class TestOverride < Test::Unit::TestCase
  context "baz" do
    setup do
      @foo = Foo.new
      override(@foo, :bar, "Hello")
    end

    should "work without arguments" do
      assert_equal "Hello", @foo.bar
    end

    should "discard arguments" do
      assert_equal "Hello", @foo.bar(1)
    end
  end

  context "sending :rewrite" do
    setup do
      @foo = Foo.new
      @foo2 = Foo.new
    end

    should "work for string returns" do
      override(@foo, :bar, "Hello")
      assert_equal "Hello", @foo.bar
    end

    should "work for numeric returns" do
      override(@foo, :bar, 23)
      assert_equal 23, @foo.bar
    end

    should "work for object returns" do
      override(@foo, :bar, @foo2)
      assert_equal @foo2, @foo.bar
    end

    should "work for methods that used to receive blocks" do
      override(@foo, :baz, "Hey!")
      assert_equal "Hey!", @foo.baz { |x| x }
    end

    should "work for methods that used to receive arguments" do
      override(@foo, :qux, "Yay!")
      assert_equal "Yay!", @foo.qux(1, 2, 3)
    end
  end
end
