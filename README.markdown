Override
============

The as-simple-as-possible-but-not-simpler stubbing library.

Description
-----------

This is the pure esence of the stubbing concept: it takes an object,
a hash of methods/results, and proceeds to rewrite each method in the
object. It can be used as a stubbing strategy in most cases, and I'd
say that cases that don't fit this pattern have a very bad code smell,
because are either dealing with internals or with side effects.

Usage
-----

    require 'override'

    @user = User.spawn
    override(@user, :name => "Foobar", :email => "foobar@example.org")
    override(User, :find => @user)

Or alternatively:

    override(User, :find => override(User.spawn, :name => "Foobar, :email => "foobar@example.org"))

In case you don't know what spawn means, check my other library for
testing at http://github.com/soveran/spawner.

Installation
------------

    $ gem sources -a http://gems.github.com (you only have to do this once)
    $ sudo gem install soveran-override

Thanks
------

Thanks to Tim Goh for his advice of using a hash for rewriting multiple
methods at once.

License
-------

Copyright (c) 2009 Michel Martens

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
