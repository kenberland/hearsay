require 'openssl'
require 'socket'
pem = '/Users/bird/Desktop/ck.pem'
#store = OpenSSL::X509::Store.new
#store.add_cert(OpenSSL::X509::Certificate.new(File.read('/home/ken/GeoTrust_Global_CA.pem')))
context      = OpenSSL::SSL::SSLContext.new
#context.cert_store = store
context.cert = OpenSSL::X509::Certificate.new(File.read(pem))
context.key  = OpenSSL::PKey::RSA.new(File.read(pem))

sock         = TCPSocket.new('gateway.sandbox.push.apple.com', 2195)
ssl          = OpenSSL::SSL::SSLSocket.new(sock,context)
ssl.connect
