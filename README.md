ldsorg-ruby-sdk
===============

A ruby library for connecting with lds.org through ldsauth / oauth2.

The library should work in two ways: connect directly by entering a username and password (commandline use) or via OAuth2.

psuedo-code usage via OAuth2
---

Ugly psuedo-code because I don't remember how you actually do this in ruby

```ruby
require ldsorg

ldsorg = LdsOrg.new({ :id => 'CLIENT_ID', :secret => 'CLIENT_SECRET', :callback => '/api/ldsauth/callback' })

routes.draw |route| {
  route.get '/dialog/authorize', 'ldsorg#authorize'
  route.get '/api/ldsauth/callback' |user| {
    me = ldsorg.get '/api/ldsorg/me', { bearer: user.accessToken }
    println me.to_json
  }
}
```

Be able to access resources as described on https://github.com/LDSorg/ldsauth using a bearer token.

psuedo-code usage via commandline
---

```ruby
require ldsorg

ldsorg = LdsOrg.new({ :username => 'joesmith', :password => 'secret' })
me = ldsorg.get '/api/ldsorg/me'
println me.to_json
```

Be able to access resources as described on https://github.com/LDSorg/ldsauth using username / password.
