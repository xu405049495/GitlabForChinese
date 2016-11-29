module ServicesHelper
  def service_event_description(event)
    case event
    when "push"
      "事件将通过推送到存储库来触发"
    when "tag_push"
      "将新标记推送到存储库时将触发事件"
    when "note"
      "当有人添加评论时将触发事件"
    when "issue"
      "创建/更新/关闭问题时将触发事件"
    when "confidential_issue"
      "创建/更新/关闭机密问题时将触发事件"
    when "merge_request"
      "创建/更新/合并合并请求时将触发事件"
    when "build"
      "构建状态更改时将触发事件"
    when "wiki_page"
      "创建/更新Wiki页面时将触发事件"
    when "commit"
      "创建/更新提交时将触发事件"
    end
  end

  def service_event_field_name(event)
    event = event.pluralize if %w[merge_request issue confidential_issue].include?(event)
    "#{event}_events"
  end
end
