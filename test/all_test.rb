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
  context "dealing with arguments" do
    setup do
      @foo = Foo.new
      override(@foo, :bar => "Hello")
    end

    should "work without arguments" do
      assert_equal "Hello", @foo.bar
    end

    should "discard arguments" do
      assert_equal "Hello", @foo.bar(1)
    end
  end

  context "accepting different return values" do
    setup do
      @foo = Foo.new
      @foo2 = Foo.new
    end

    should "work for string returns" do
      override(@foo, :bar => "Hello")
      assert_equal "Hello", @foo.bar
    end

    should "work for numeric returns" do
      override(@foo, :bar => 23)
      assert_equal 23, @foo.bar
    end

    should "work for object returns" do
      override(@foo, :bar => @foo2)
      assert_equal @foo2, @foo.bar
    end
  end

  context "working with methods that acepted attributes or blocks" do
    setup do
      @foo = Foo.new
    end

    should "work for methods that used to receive blocks" do
      override(@foo, :baz => "Hey!")
      assert_equal "Hey!", @foo.baz { |x| x }
    end

    should "work for methods that used to receive arguments" do
      override(@foo, :qux => "Yay!")
      assert_equal "Yay!", @foo.qux(1, 2, 3)
    end
  end

  context "rewriting multiple methods at once" do
    should "override all the passed methods" do
      override(@foo, :bar => 1, :baz => 2, :qux => 3)
      assert_equal 1, @foo.bar
      assert_equal 2, @foo.baz
      assert_equal 3, @foo.qux
    end
  end

  context "chaining successive calls" do
    should "return the object and allow chained calls" do
      assert_equal 1, override(@foo, :bar => 1).bar
    end
  end
end
