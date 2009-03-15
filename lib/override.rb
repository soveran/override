# Override
#
# This is the pure esence of the stubbing concept: it takes an object, a
# method and the desired result, and proceeds to rewrite the method in
# the object. It can be used as a stubbing strategy in most cases, and
# I'd say that cases that don't fit this pattern have a very bad smell
# because are either dealing with internals or with side effects.
#
# Usage:
#
#   @user = User.spawn
#   override(@user, :name => "Foobar", :email => "foobar@example.org")
#   override(User, :find => @user)
#
# In case you don't know what spawn means, check my other library for
# testing at http://github.com/soveran/spawner.
#
# Note: the arity strictness in Ruby 1.9 demands for that trick that
# drops the arguments passed to the redefined method. It's not necessary
# in Ruby 1.8.
#
require "rubygems"
require "metaid"

def override object, methods
  methods.each do |method, result|
    object.metaclass.send(:define_method, method) do |*_|
      result
    end
  end
end
