# Override
#
# This is the pure esence of the stubbing concept: it takes an object,
# a hash of methods/results, and proceeds to rewrite each method in the
# object. It can be used as a stubbing strategy in most cases, and I'd
# say that cases that don't fit this pattern have a very bad code smell,
# because are either dealing with internals or with side effects.
#
# Usage
#
#     require 'override'
#
#     @user = User.spawn
#     override(@user, :name => "Foobar", :email => "foobar@example.org")
#     override(User, :find => @user)
#
# Or alternatively:
#
#     override(User, :find => override(User.spawn, :name => "Foobar, :email => "foobar@example.org"))
#
# In case you don't know what spawn means, check my other library for
# testing at http://github.com/soveran/spawner.
#
# Note: the arity strictness in Ruby 1.9 demands for that trick that
# drops the arguments passed to the redefined method. It's not necessary
# in Ruby 1.8.
#
# You can also send lambdas that will become the body of the redefined method:
#
#     user = User.spawn :name => "Foobar"
#     override(User, :find => lambda { |id| raise ArgumentError unless id == 1; user })
#
# And then, in your tests:
#
#     assert_raise ArgumentError do
#       User.find(2)
#     end
#
#     assert_nothing_raised do
#       User.find(1)
#     end
#
#     assert_equal "Foobar", User.find(1).name
#
# It is a common pattern to set expectations for method calls. You can
# do it with the expect function:
#
#     user = User.spawn :name => "Foobar"
#     expect(User, :find, :return => user, :params => [:first, { :include => :friendships }])
#
# And then:
#
#     assert_equal "Foobar", User.find(:first, :include => :friendships).name
#     assert_raise ArgumentError do
#       User.find(:all)
#     end
#
require "rubygems"
require "metaid"

def override object, methods
  methods.each do |method, result|
    result.respond_to?(:to_proc) ?
      object.meta_def(method, &result.to_proc) :
      object.meta_def(method) { |*_| result }
  end

  object
end

def expect object, method, options
  expectation = lambda do |*params|
    raise ArgumentError unless params == options[:params]
    options[:return]
  end

  override(object, method => expectation)
end
