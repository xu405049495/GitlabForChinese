require 'asana'

class AsanaService < Service
  prop_accessor :api_key, :restrict_to_branch
  validates :api_key, presence: true, if: :activated?

  def title
    'Asana'
  end

  def description
    'Asana - 没有电子邮件的团队合作'
  end

  def help
    '此服务将提交消息作为注释添加到Asana任务。
启用后，将检查提交邮件是否包含Asana任务网址（例如，“https：// app.asana.com / 0/123456/987654”）或以＃开头的任务ID（例如，＃987654）。找到的每个任务ID将获得添加的提交注释。
您还可以使用包含以下内容的消息关闭任务：`fix＃123456`。
您可以在此处创建个人访问令牌：
http://app.asana.com/-/account_api'
  end

  def to_param
    'asana'
  end

  def fields
    [
      {
        type: 'text',
        name: 'api_key',
        placeholder: '用户个人访问令牌。用户必须有权访问任务，所有评论都将归因于此用户。'
      },
      {
        type: 'text',
        name: 'restrict_to_branch',
        placeholder: '将自动检查的分支的逗号分隔列表。留为空白以包括所有分支。'
      }
    ]
  end

  def supported_events
    %w(push)
  end

  def client
    @_client ||= begin
      Asana::Client.new do |c|
        c.authentication :access_token, api_key
      end
    end
  end

  def execute(data)
    return unless supported_events.include?(data[:object_kind])

    # check the branch restriction is poplulated and branch is not included
    branch = Gitlab::Git.ref_name(data[:ref])
    branch_restriction = restrict_to_branch.to_s
    if branch_restriction.length > 0 && branch_restriction.index(branch).nil?
      return
    end

    user = data[:user_name]
    project_name = project.name_with_namespace

    data[:commits].each do |commit|
      push_msg = "#{user} 推送了 #{project_name} 的 #{branch} 分支 ( #{commit[:url]} )："
      check_commit(commit[:message], push_msg)
    end
  end

  def check_commit(message, push_msg)
    # matches either:
    # - #1234
    # - https://app.asana.com/0/0/1234
    # optionally preceded with:
    # - fix/ed/es/ing
    # - close/s/d
    # - closing
    issue_finder = /(fix\w*|clos[ei]\w*+)?\W*(?:https:\/\/app\.asana\.com\/\d+\/\d+\/(\d+)|#(\d+))/i

    message.scan(issue_finder).each do |tuple|
      # tuple will be
      # [ 'fix', 'id_from_url', 'id_from_pound' ]
      taskid = tuple[2] || tuple[1]

      begin
        task = Asana::Task.find_by_id(client, taskid)
        task.add_comment(text: "#{push_msg} #{message}")

        if tuple[0]
          task.update(completed: true)
        end
      rescue => e
        Rails.logger.error(e.message)
        next
      end
    end
  end
end
