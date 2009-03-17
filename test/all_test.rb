require 'test/unit'
require 'rubygems'
require 'contest'

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

class Callable
  def to_proc
    lambda do |name|
      "Hello #{name}"
    end
  end
end

class TestOverride < Test::Unit::TestCase
  context "dealing with arguments" do
    setup do
      @foo = Foo.new
      override(@foo, :bar => "Hello")
    end

    test "work without arguments" do
      assert_equal "Hello", @foo.bar
    end

    test "discard arguments" do
      assert_equal "Hello", @foo.bar(1)
    end
  end

  context "accepting different return values" do
    setup do
      @foo = Foo.new
      @foo2 = Foo.new
    end

    test "work for string returns" do
      override(@foo, :bar => "Hello")
      assert_equal "Hello", @foo.bar
    end

    test "work for numeric returns" do
      override(@foo, :bar => 23)
      assert_equal 23, @foo.bar
    end

    test "work for object returns" do
      override(@foo, :bar => @foo2)
      assert_equal @foo2, @foo.bar
    end
  end

  context "working with methods that acepted attributes or blocks" do
    setup do
      @foo = Foo.new
    end

    test "work for methods that used to receive blocks" do
      override(@foo, :baz => "Hey!")
      assert_equal "Hey!", @foo.baz { |x| x }
    end

    test "work for methods that used to receive arguments" do
      override(@foo, :qux => "Yay!")
      assert_equal "Yay!", @foo.qux(1, 2, 3)
    end
  end

  context "rewriting multiple methods at once" do
    test "override all the passed methods" do
      override(@foo, :bar => 1, :baz => 2, :qux => 3)
      assert_equal 1, @foo.bar
      assert_equal 2, @foo.baz
      assert_equal 3, @foo.qux
    end
  end

  context "chaining successive calls" do
    test "return the object and allow chained calls" do
      assert_equal 1, override(@foo, :bar => 1).bar
    end
  end

  context "dealing with a proc as the result value" do
    test "uses the proc as the body of the method" do
      override(@foo, :bar => lambda { |name| "Hello #{name}" })
      assert_equal "Hello World", @foo.bar("World")
    end
  end

  context "using assert raise with lambdas" do
    setup do
      class User
        def name
          "Michel"
        end
      end

      user = User.new
      override(@foo, :bar => lambda { |id| raise ArgumentError unless id == 1; user })
    end

    test "lambdas should be able to raise exceptions" do
      assert_raise ArgumentError do
        @foo.bar(2)
      end

      assert_nothing_raised do
        @foo.bar(1)
      end

      assert_equal "Michel", @foo.bar(1).name
    end
  end

  context "documenting a gotcha with lambdas" do
    setup do
      name = "Michel"
      @name = "Michel"
      override(@foo, :bar => lambda { name })
      override(@foo, :baz => lambda { @name })
    end

    test "succeeds when the lambda returns a local variable" do
      assert_equal "Michel", @foo.bar
    end

    test "fails when the lambda is supposed to return an instance variable" do
      assert_equal nil, @foo.baz
    end
  end

  context "using objects that respond to to_proc" do
    setup do
      override(@foo, :bar => Callable.new)
    end

    test "coerces the value into a proc" do
      assert_equal "Hello World", @foo.bar("World")
    end
  end

  context "supporting procs as return values" do
    setup do
      override(@foo, :bar => lambda { lambda { "Hey!" } })
    end

    test "returns a lambda if it's wraped inside a proc" do
      assert_equal "Hey!", @foo.bar.call
    end
  end

  context "setting expectations" do
    setup do
      expect(@foo, :bar, :return => true, :params => ["Michel", 32])
    end

    test "raises an error if expectations are not met" do
      assert_raise ArgumentError do
        @foo.bar "Michel", 31
      end
    end

    test "succeeds if expectations are met" do
      assert_nothing_raised do
        @foo.bar "Michel", 32
      end
    end
  end

  context "setting expectations with hashes in the param list" do
    setup do
      expect(@foo, :bar, :return => true, :params => ["Michel", { :include => :friendships, :select => "name" }])
    end

    test "succeeds if expectations are met" do
      assert_nothing_raised do
        @foo.bar "Michel", { :select => "name", :include => :friendships, :select => "name" }
      end
    end
  end
end
