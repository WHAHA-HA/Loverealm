require 'faye'
require 'yaml'

Faye::WebSocket.load_adapter('thin')
CONFIG = YAML.load(::File.read(File.expand_path('../config/faye.yml', __FILE__)))


class ServerAuth
  def incoming(message, callback)
    puts message.inspect
    if message['channel'] !~ %r{^/meta/}
      if message['ext'].nil? || message['ext']['auth_token'] != CONFIG['auth_token']
        message['error'] = 'Invalid authentication token.'
      end

    end

    # You must subbrscribe to the exacth chanell
    if message['subscription'] =~ /\*/
      message['error'] = 'No wildcards.'
    end
    message.delete('ext')
    callback.call(message)
  end
end

faye_server = Faye::RackAdapter.new(:mount => ENV['FAYE_URL'], timeout: 45)
faye_server.add_extension(ServerAuth.new)
run faye_server
