class BuildsEmailService < Service
  prop_accessor :recipients
  boolean_accessor :add_pusher
  boolean_accessor :notify_only_broken_builds
  validates :recipients, presence: true, if: ->(s) { s.activated? && !s.add_pusher? }

  def initialize_properties
    if properties.nil?
      self.properties = {}
      self.notify_only_broken_builds = true
    end
  end

  def title
    '构建邮件'
  end

  def description
    '将构建状态通过电子邮件发送给收件人列表。'
  end

  def to_param
    'builds_email'
  end

  def supported_events
    %w(build)
  end

  def execute(push_data)
    return unless supported_events.include?(push_data[:object_kind])
    return unless should_build_be_notified?(push_data)

    recipients = all_recipients(push_data)

    if recipients.any?
      BuildEmailWorker.perform_async(
        push_data[:build_id],
        recipients,
        push_data
      )
    end
  end

  def can_test?
    project.builds.any?
  end

  def disabled_title
    "请在您的存储库上设置一个构建。"
  end

  def test_data(project = nil, user = nil)
    Gitlab::DataBuilder::Build.build(project.builds.last)
  end

  def fields
    [
      { type: 'textarea', name: 'recipients', placeholder: '电子邮件以逗号分隔' },
      { type: 'checkbox', name: 'add_pusher', label: '将推送器添加到收件人列表' },
      { type: 'checkbox', name: 'notify_only_broken_builds' },
    ]
  end

  def test(data)
    begin
      # bypass build status verification when testing
      data[:build_status] = "failed"
      data[:build_allow_failure] = false

      result = execute(data)
    rescue StandardError => error
      return { success: false, result: error }
    end

    { success: true, result: result }
  end

  def should_build_be_notified?(data)
    case data[:build_status]
    when 'success'
      !notify_only_broken_builds?
    when 'failed'
      !allow_failure?(data)
    else
      false
    end
  end

  def allow_failure?(data)
    data[:build_allow_failure] == true
  end

  def all_recipients(data)
    all_recipients = []

    unless recipients.blank?
      all_recipients += recipients.split(',').compact.reject(&:blank?)
    end

    if add_pusher? && data[:user][:email]
      all_recipients << data[:user][:email]
    end

    all_recipients
  end
end
