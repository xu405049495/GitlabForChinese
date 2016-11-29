class CustomIssueTrackerService < IssueTrackerService
  validates :project_url, :issues_url, :new_issue_url, presence: true, url: true, if: :activated?

  prop_accessor :title, :description, :project_url, :issues_url, :new_issue_url

  def title
    if self.properties && self.properties['title'].present?
      self.properties['title']
    else
      '自定义问题跟踪器'
    end
  end

  def title=(value)
    self.properties['title'] = value if self.properties
  end

  def description
    if self.properties && self.properties['description'].present?
      self.properties['description']
    else
      '自定义问题跟踪器'
    end
  end

  def to_param
    'custom_issue_tracker'
  end

  def fields
    [
      { type: 'text', name: 'title', placeholder: title },
      { type: 'text', name: 'description', placeholder: description },
      { type: 'text', name: 'project_url', placeholder: '项目 url' },
      { type: 'text', name: 'issues_url', placeholder: '问题 url' },
      { type: 'text', name: 'new_issue_url', placeholder: '新问题 url' }
    ]
  end
end
