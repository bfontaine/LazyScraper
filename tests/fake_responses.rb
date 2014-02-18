#! /usr/bin/env ruby
# -*- coding: UTF-8 -*-

require 'fakeweb'

FakeWeb.allow_net_connect = false

# This simulate a fake website called FooBar,
# with users' profiles at
#   foo.bar/user/:id
# and their bio at
#   foo.bar/user/:id/bio
#
# We'll create one profile

FakeWeb.register_uri(
  :get,
  'http://foo.bar/user/42',
  :body => <<-EOB
    <html>
    <body>
      <h1>Foo Bar</h1>
      <h2>John Doe's profile</h2>
      <p>Hi I'm John Doe</p>
      <ul class="counts">
        <li><span>42</span> favorites</li>
        <li><span>12</span> reviews</li>
        <li><span>0</span> friends</li>
      </ul>
    </body>
    </html>
  EOB
)

FakeWeb.register_uri(
  :get,
  'http://foo.bar/user/42/bio',
  :body => <<-EOB
    <html>
    <body>
      <h1>Foo Bar</h1>
      <h2>John Doe's bio</h2>
      <p>Hi I'm John Doe and this is my bio</p>
      <p>Donec sed odio dui.</p>
      <p>Nullam id dolor id nibh ultricies vehicula ut id elit.
      Cras mattis consectetur purus sit amet fermentum.</p>
    </body>
    </html>
  EOB
)

