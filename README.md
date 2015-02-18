lds-connect-ruby
===============

Connect with lds.org through ldsconnect.org using OAuth2 (Facebook Connect) with Ruby and Sinatra

Usage
===

The library should work in two ways: connect directly by entering a username and password (commandline use) or via OAuth2.

```bash
# Clone the server
git clone git@github.com:LDSorg/lds-connect-ruby.git
pushd lds-connect-ruby

# Clone the example HTTPS/SSL certificates into ./certs
git clone git@github.com:LDSorg/local.ldsconnect.org-certificates.git ./certs
tree -I .git ./certs

# Install Bundler (if you don't have it)
sudo gem install bundler

# Install all dependencies
bundle install
```

### Choose your front-end

If you want to go with the jQuery example, you would do this (exactly):

```bash
# Clone the front-end you like best into ./public
git clone git@github.com:LDSorg/oauth2-jquery ./public
```

### Edit Config and Start Server

```bash
# Edit the config file, if desired
vim ./.env

# Run the sinatra server
ruby ./app.rb
```

### Visit <https://local.ldsconnect.org:4080>

You **CANNOT** use `https://localhost:4080` or `https://127.0.0.1` -
most OAuth providers don't accept false domains.
The certificates are signed for `local.ldsconnect.org` so that you can use this example
with a wide variety of providers.
