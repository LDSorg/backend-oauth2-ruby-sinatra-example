lds-connect-ruby-example
===============

A minimal example using the OAuth2 (Facebook Connect) and ldsconnect gems with ruby v2.0+ to get an
lds.org (or Facebook) user profile.

Zero-Config Install and Run
================

Connect with lds.org through ldsconnect.org using OAuth2 (Facebook Connect) with Ruby and Sinatra

You can start working with test user data immediately.

1. Clone Backend
----------------

```bash
# Clone the server
git clone git@github.com:LDSorg/lds-connect-ruby.git
pushd lds-connect-ruby

# Install Bundler (if you don't have it)
sudo gem install bundler

# Install all dependencies
bundle install
```

2. Clone SSL Certs
------------------

```bash
# Clone the example HTTPS/SSL certificates into ./certs
git clone git@github.com:LDSorg/local.ldsconnect.org-certificates.git ./certs
tree -I .git ./certs
```

3. Clone Frontend
-----------------

You need to clone the frontend 

See [github.com/ldsorg](https://github.com/ldsorg?query=oauth2-) for a list of frontends examples / seed projects.

```bash
# The jQuery Example
git clone git@github.com:LDSorg/oauth2-jquery public
```

**Note**: If you use the AngularJS frontend you will also need to run `bower install`.

```bash
# Used for the AngularJS Example (not needed for jQuery)
npm install -g bower

pushd public
bower install
popd
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


5. Login as dumbledore
-----------

You **cannot** login as a real lds.org user as a test application.
If you try, you will get an error.

The login you must use for test applications is `dumbledore` with the passphrase `secret`.

6. Modifying the Example
-----------------

The config is stored in `.env`

```bash
# Edit the config file, if desired
vim ./.env
```

If you use your own certs and need to change the names rather than simply copy them over,
you can change them in `./sinatra_ssl.rb`


Credits
======

Muchas Gracias a [@ryanburnette](https://twitter.com/ryanburnette) for creating this!

Thanks also to <https://stackoverflow.com/questions/2362148/how-to-enable-ssl-for-a-standalone-sinatra-app>

### TODO

Maybe use something like https://github.com/tobmatth/rack-ssl-enforcer or https://github.com/josh/rack-ssl
