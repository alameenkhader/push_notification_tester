require_relative 'ios_notifier'

class ApnsForm
  def initialize(data)
    @data = data
  end

  def process
    ios_notifier.push(@data)
  end

  private

  def certificate
    @data[:certificate][:tempfile]
  end

  def password
    @data[:password] unless @data[:password].empty?
  end

  def ios_notifier
    IosNotifier.new(certificate, password)
  end
end
