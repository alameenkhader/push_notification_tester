require 'apnotic'

class IosNotifier
  attr_accessor :certificate, :password

  def initialize(certificate, password = nil)
    @certificate = certificate # expects a pem file
    @password = password
  end

  def client
    @client ||= Apnotic::Connection.new(cert_path: @certificate, cert_pass: @password)
  end

  def notification(data)
    n                   = Apnotic::Notification.new(data[:token])
    n.alert             = data[:alert]
    n.topic             = data[:topic]
    n.custom_payload    = custom_payload(data)
    n.badge             = badge(data)
    n.sound             = sound(data)
    n.category          = category(data)
    n.content_available = data[:content_available]
    n.mutable_content   = data[:mutable_content]
    n
  end

  def push(data)
    notif    = notification(data)
    request  = Apnotic::Request.new(notif)
    response = client.push(notif)
    client.close
    [request, response]
  end

  private

  def custom_payload(data)
    JSON.parse(data[:custom_payload])
  rescue JSON::ParserError
    return { custom_payload: data[:custom_payload] }
  end

  def badge(data)
    data[:badge] unless data[:badge].empty?
  end

  def sound(data)
    data[:sound] unless data[:sound].empty?
  end

  def category(data)
    data[:category] unless data[:category].empty?
  end
end
