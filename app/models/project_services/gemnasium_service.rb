require "gemnasium/gitlab_service"

class GemnasiumService < Service
  prop_accessor :token, :api_key
  validates :token, :api_key, presence: true, if: :activated?

  def title
    'Gemnasium'
  end

  def description
    'Gemnasium监视您的项目依赖关系，并提醒您有关更新和安全漏洞。'
  end

  def to_param
    'gemnasium'
  end

  def fields
    [
      { type: 'text', name: 'api_key', placeholder: 'gemnasium.com上的您的个人API密钥 ' },
      { type: 'text', name: 'token', placeholder: '该项目在gemnasium.com上的授权' }
    ]
  end

  def supported_events
    %w(push)
  end

  def execute(data)
    return unless supported_events.include?(data[:object_kind])

    Gemnasium::GitlabService.execute(
      ref: data[:ref],
      before: data[:before],
      after: data[:after],
      token: token,
      api_key: api_key,
      repo: project.repository.path_to_repo
    )
  end
end
