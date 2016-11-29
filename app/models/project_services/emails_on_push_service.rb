class EmailsOnPushService < Service
  prop_accessor :send_from_committer_email
  prop_accessor :disable_diffs
  prop_accessor :recipients
  validates :recipients, presence: true, if: :activated?

  def title
    '推送电子邮件'
  end

  def description
    '将每次推送的提交和差异通过电子邮件发送给收件人列表。'
  end

  def to_param
    'emails_on_push'
  end

  def supported_events
    %w(push tag_push)
  end

  def execute(push_data)
    return unless supported_events.include?(push_data[:object_kind])

    EmailsOnPushWorker.perform_async(
      project_id, 
      recipients, 
      push_data, 
      send_from_committer_email:  send_from_committer_email?, 
      disable_diffs:              disable_diffs?
    )
  end

  def send_from_committer_email?
    self.send_from_committer_email == "1"
  end

  def disable_diffs?
    self.disable_diffs == "1"
  end

  def fields
    domains = Notify.allowed_email_domains.map { |domain| "user@#{domain}" }.join(", ")
    [
      { type: 'checkbox', name: 'send_from_committer_email', title: "从提交者发送",
        help: "如果域是GitLab正在运行的域 (例如： #{domains})的一部分，则从提交者的电子邮件地址发送通知。" },
      { type: 'checkbox', name: 'disable_diffs', title: "停用代码差异",
        help: "不要在通知正文中包括可能敏感的代码差异。" },
      { type: 'textarea', name: 'recipients', placeholder: '以空格分隔的电子邮件' },
    ]
  end
end
