require 'uri'

class IrkerService < Service
  prop_accessor :server_host, :server_port, :default_irc_uri
  prop_accessor :colorize_messages, :recipients, :channels
  validates :recipients, presence: true, if: :activated?

  before_validation :get_channels

  def title
    'Irker (IRC 网关)'
  end

  def description
    '在更新时，通过Irker网关将IRC邮件发送到收件人列表。'
  end

  def to_param
    'irker'
  end

  def supported_events
    %w(push)
  end

  def execute(data)
    return unless supported_events.include?(data[:object_kind])

    IrkerWorker.perform_async(project_id, channels,
                              colorize_messages, data, settings)
  end

  def settings
    { server_host: server_host.present? ? server_host : 'localhost',
      server_port: server_port.present? ? server_port : 6659
    }
  end

  def fields
    [
      { type: 'text', name: 'server_host', placeholder: 'localhost',
        help: 'Irker守护程序主机名（默认为localhost）' },
      { type: 'text', name: 'server_port', placeholder: 6659,
        help: 'Irker守护程序端口（默认为6659）' },
      { type: 'text', name: 'default_irc_uri', title: '默认 IRC URI',
        help: '在每个收件人之前添加的默认IRC URI（可选）',
        placeholder: 'irc://irc.network.net:6697/' },
      { type: 'textarea', name: 'recipients',
        placeholder: '由空格分隔的收件人/频道',
        help: '收件人必须使用完整的URI指定：irc [s]：//irc.network.net [：port] /＃channel。特殊情况：如果您希望频道成为昵称，请将“，isnick”附加到频道名称;如果通道受到保密密码保护，请将“？key = secretpassword”附加到URI（注意，由于错误，如果要使用密码，则必须忽略通道上的“＃”）。如果您指定一个默认IRC URI以在每个收件人之前进行预付，您只需给出一个频道名称。'  },
      { type: 'checkbox', name: 'colorize_messages' },
    ]
  end

  def help
    ' 注意：Irker没有内置的身份验证，这使得它容易被垃圾邮件IRC通道，如果它托管在防火墙之外。请确保您在安全网络中运行守护程序以防止滥用。有关更多详细信息，请参阅：http：//www.catb.org/~esr/irker/security.html。'
  end

  private

  def get_channels
    return true unless activated?
    return true if recipients.nil? || recipients.empty?

    map_recipients

    errors.add(:recipients, 'are all invalid') if channels.empty?
    true
  end

  def map_recipients
    self.channels = recipients.split(/\s+/).map do |recipient|
      format_channel(recipient)
    end
    channels.reject!(&:nil?)
  end

  def format_channel(recipient)
    uri = nil

    # Try to parse the chan as a full URI
    begin
      uri = consider_uri(URI.parse(recipient))
    rescue URI::InvalidURIError
    end

    unless uri.present? and default_irc_uri.nil?
      begin
        new_recipient = URI.join(default_irc_uri, '/', recipient).to_s
        uri = consider_uri(URI.parse(new_recipient))
      rescue
        Rails.logger.error("Unable to create a valid URL from #{default_irc_uri} and #{recipient}")
      end
    end

    uri
  end

  def consider_uri(uri)
    return nil if uri.scheme.nil?

    # Authorize both irc://domain.com/#chan and irc://domain.com/chan
    if uri.is_a?(URI) && uri.scheme[/^ircs?\z/] && !uri.path.nil?
      uri.to_s
    end
  end
end
