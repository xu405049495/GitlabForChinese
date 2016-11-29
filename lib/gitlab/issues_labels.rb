module Gitlab
  class IssuesLabels
    class << self
      def generate(project)
        red = '#d9534f'
        yellow = '#f0ad4e'
        blue = '#428bca'
        green = '#5cb85c'

        labels = [
          { title: "缺陷", color: red },
          { title: "危急", color: red },
          { title: "已确认", color: red },
          { title: "文档", color: yellow },
          { title: "支持", color: yellow },
          { title: "讨论", color: blue },
          { title: "建议", color: blue },
          { title: "增强", color: green }
        ]

        labels.each do |params|
          ::Labels::FindOrCreateService.new(nil, project, params).execute(skip_authorization: true)
        end
      end
    end
  end
end
