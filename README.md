lds-connect-ruby-example
===============

A minimal example using the OAuth2 (Facebook Connect) and ldsconnect gems with ruby v2.0+ to get an
lds.org (or Facebook) user profile.

The Easy Way: Zero-Config Install and Run
================

Connect with lds.org through ldsconnect.org using OAuth2 (Facebook Connect) with Ruby and Sinatra

You can start working with test user data immediately.

```bash
curl -fsSL https://bit.ly/install-lds-api-technical-demo-ruby | bash
```

The Hard Way
============

1. Clone Backend
----------------

```bash
# Clone the server
git clone https://github.com/LDSorg/lds-connect-ruby.git
pushd lds-connect-ruby

# Install Bundler (if you don't have it)
sudo gem install bundler

# Install all dependencies
bundle install

# Copy the sample app keys db
rsync -av db.sample.json db.json
```

2. Clone SSL Certs
------------------

```bash
# Clone the example HTTPS/SSL certificates into ./certs
git clone https://github.com/LDSorg/local.ldsconnect.org-certificates.git ./certs
tree -I .git ./certs
```

3. Clone Frontend
-----------------

You need to clone the frontend 

See [github.com/ldsorg](https://github.com/ldsorg?query=frontend-) for a list of frontends examples / seed projects.

```bash
# The jQuery Example
git clone https://github.com/LDSorg/frontend-oauth2-jquery-example.git public
```

You'll also need to install a few small dependencies (oauth3 and lds-api)

```bash
# The jQuery Example
npm install -g bower

bower install
```

Copy the default config file

```bash
rsync -av db.sample.json db.json
```

3. Run Server
-------------

```bash
# Run the sinatra server
ruby ./app.rb
```

4. Go to <https://local.ldsconnect.org:8043>
----------

**This domain points to YOUR computer**.

**DO NOT USE 127.0.0.1 or localhost**.

<https://local.ldsconnect.org:8043> uses a valid SSL certificate for
HTTPS and points to 127.0.0.1.

Even in development you should never be using insecure connections.
Welcome to 2015. [Get used to it](https://letsencrypt.org)!

The development test keys are already installed. Once you've fired up the
server navigate to <https://local.ldsconnect.org:8043>.

**Note**:
It's important that you use `local.ldsconnect.org` rather than `localhost`
because the way that many OAuth2 implementations validate domains requires
having an actual domain. Also, you will be testing with **SSL on** so that
your development environment mirrors your production environment.

Again, you **CANNOT** use `https://localhost:8043` or `https://127.0.0.1:8043` -
most OAuth providers don't accept false domains.
The certificates are signed for `local.ldsconnect.org` so that you can use this example
with a wide variety of providers.

5. Login
-----------

Currently you must log in as a real LDS.org user. In the future I'd like to have a dummy user available
so that you can explore the technical aspects of the api without logging in
(and skilled non-members can help us out too).

6. Modifying the Example
-----------------

The config is stored in `db.json`

```bash
# Edit the config file, if desired
vim ./db.json
```

If you use your own certs and need to change the names rather than simply copy them over,
you can change them in `./sinatra_ssl.rb`


Credits
======

Muchas Gracias a [@ryanburnette](https://twitter.com/ryanburnette) for creating this!

Thanks also to <https://stackoverflow.com/questions/2362148/how-to-enable-ssl-for-a-standalone-sinatra-app>

### TODO

Maybe use something like https://github.com/tobmatth/rack-ssl-enforcer or https://github.com/josh/rack-ssl
