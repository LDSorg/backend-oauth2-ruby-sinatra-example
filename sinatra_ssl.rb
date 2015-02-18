require 'webrick/https'

SERVER_SSL_KEY='./certs/server/my-server.key.pem'
SERVER_SSL_CRT='./certs/server/my-server.crt.pem'
CA_SSL_CRT='./certs/ca/'
#CA_INT_SSL_CRT='./certs/ca/intermediate.crt.pem'
#CA_ROOT_SSL_CRT='./certs/ca/root.crt.pem'

module Sinatra
  class Application
    def self.run!
      certificate_content = File.open(SERVER_SSL_CRT).read
      key_content = File.open(SERVER_SSL_KEY).read

      server_options = {
        :Host => bind,
        :Port => port,
        :SSLEnable => true,
        :SSLCertificate => OpenSSL::X509::Certificate.new(certificate_content),
        :SSLPrivateKey => OpenSSL::PKey::RSA.new(key_content),
        :SSLCACertificatePath => CA_SSL_CRT
      }

      Rack::Handler::WEBrick.run self, server_options do |server|
        [:INT, :TERM].each { |sig| trap(sig) { server.stop } }
        server.threaded = settings.threaded if server.respond_to? :threaded=
        set :running, true
      end
    end
  end
end
