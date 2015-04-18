#!/bin/bash
set -e
set -u

FC_FRONTEND_DIR=""

#curl -fsSL https://bit.ly/install-lds-api-technical-demo-ruby | bash

echo "Cloning Frontend-Developer Backend (https static file server with oauth3)..."
git clone https://github.com/LDSorg/backend-oauth2-ruby-sinatra-example.git ./lds-api-ruby-demo \
  > /dev/null 2> /dev/null
pushd ./lds-api-ruby-demo > /dev/null

echo "Installing Sinatra Static File Server... (this will take several seconds)"
bundle install > /dev/null

echo "Cloning Developer HTTPS Certificates for https://local.ldsconnect.org:8043..."
git clone https://github.com/LDSorg/local.ldsconnect.org-certificates.git ./certs \
  > /dev/null 2> /dev/null

echo "Cloning the facecards.org-frontend and creating ./public link"
git clone https://github.com/LDSorg/frontend-oauth2-jquery-example.git ./frontend-jquery \
  > /dev/null 2> /dev/null
ln -s ./frontend-jquery public > /dev/null

echo "Installing Bower Components... (this will take several seconds, maybe a minute)"
pushd ./frontend > /dev/null
bower install --silent > /dev/null
#jade app/**/*.jade
FC_FRONTEND_DIR="$(pwd)"
popd

echo ""
echo ""
echo "###############################################"
echo "#                                             #"
echo "#   READY! Here's what you need to do next:   #"
echo "#                                             #"
echo "###############################################"
echo ""

echo "1. Open up a new tab and run the server like so:"
echo ""
echo "    pushd" "$(pwd)"
echo "    ruby ./app.rb"
echo ""
echo ""

echo "2. Open up yet another new tab and take a look at the frontend:"
echo ""
echo "    pushd" "$FC_FRONTEND_DIR"
echo "    tree ./ -I bower_components"
echo ""
echo "  This is where you can edit files to your heart's content"
echo ""

echo "3. Open up your web browser and fire it up to the project:"
echo ""
echo "    https://local.ldsconnect.org:8043"
echo ""
echo ""
