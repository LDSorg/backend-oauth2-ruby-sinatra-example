# LDS API OAuth2 ruby example

A minimal backend example using the [oauth3](https://github.com/OAuth3/ruby-oauth3) gem and sinatra
to get an lds.org user profile via [LDS I/O](https://lds.io).

This backend is part of the LDS API
[Choose your own Adventure](https://github.com/LDSorg/choose-your-own-adventure) series.

That means that you can **couple this backend** with **any compatible frontend** example and start
developing with Zero Configuration.

Zero-Config Install and Run
================

You can start working with test user data immediately.

```bash
curl -fsSL https://bit.ly/lds-api-adventure -o adventure.bash
bash ./adventure.bash ruby jquery
```

No configuration changes are required and working test API keys are provided.

You will be able to experiment at <https://local.ldsconnect.org:8043>

The "Hard" Way
==============

If you don't have io.js or node.js already installed,
[install it](https://github.com/coolaj86/iojs-install-script) and come back.

(even though this example runs in ruby, some of the required build tools are in node)

1. Clone Backend
----------------

See [github.com/ldsorg](https://github.com/ldsorg?query=backend-) for a list of backends examples / seed projects.

```bash
# Clone the server
git clone https://github.com/LDSorg/backend-oauth2-ruby-sinatra-example.git ./backend-oauth2-ruby
pushd ./backend-oauth2-ruby

# Install Bundler (if you don't have it)
sudo gem install bundler

# Install all dependencies
bundle install

# Copy the sample app keys db
rsync -av db.sample.json db.json
```


2. Clone SSL Certs
------------------

These certs are authentically valid for `local.ldsconnect.org`, which you are required to use during development.

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
git clone https://github.com/LDSorg/frontend-oauth2-jquery-example.git ./frontend-oauth2-jquery
rm -f public
ln -s frontend-oauth2-jquery public
```

```bash
npm install -g bower

pushd ./frontend-oauth2-jquery
bower install
popd
```

4. Run Server
-------------

```bash
ruby ./app.rb
```

5. Go to <https://local.ldsconnect.org:8043>
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
