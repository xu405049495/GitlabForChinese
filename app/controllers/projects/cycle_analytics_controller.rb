class Projects::CycleAnalyticsController < Projects::ApplicationController
  include ActionView::Helpers::DateHelper
  include ActionView::Helpers::TextHelper
  include CycleAnalyticsParams

  before_action :authorize_read_cycle_analytics!

  def show
    @cycle_analytics = ::CycleAnalytics.new(@project, from: start_date(cycle_analytics_params))

    stats_values, cycle_analytics_json = generate_cycle_analytics_data

    @cycle_analytics_no_data = stats_values.blank?

    respond_to do |format|
      format.html
      format.json { render json: cycle_analytics_json }
    end
  end

  private

  def cycle_analytics_params
    return {} unless params[:cycle_analytics].present?

    { start_date: params[:cycle_analytics][:start_date] }
  end

  def generate_cycle_analytics_data
    stats_values = []

    cycle_analytics_view_data = [[:issue, "问题", "问题排定之前的时间"],
                                 [:plan, "计划", "问题开始实施之前的时间"],
                                 [:code, "开发", "首次合并请求之前的时间"],
                                 [:test, "测试", "所有提交/合并的总测试时间"],
                                 [:review, "评审", "合并请求创建和合并/关闭之间的时间"],
                                 [:staging, "排期", "从合并请求合并到部署到生产"],
                                 [:production, "生产", "从问题创建到部署到生产"]]

    stats = cycle_analytics_view_data.reduce([]) do |stats, (stage_method, stage_text, stage_legend, stage_description)|
      value = @cycle_analytics.send(stage_method).presence

      stats_values << value.abs if value

      stats << {
        title: stage_text,
        description: stage_description,
        legend: stage_legend,
        value: value && !value.zero? ? distance_of_time_in_words(value) : nil
      }

      stats
    end

    issues = @cycle_analytics.summary.new_issues
    commits = @cycle_analytics.summary.commits
    deploys = @cycle_analytics.summary.deploys

    summary = [
      { title: "新问题", value: issues },
      { title: "提交", value: commits },
      { title: "部署", value: deploys }
    ]

    cycle_analytics_hash = { summary: summary,
                             stats: stats,
                             permissions: @cycle_analytics.permissions(user: current_user)
    }

    [stats_values, cycle_analytics_hash]
  end
end
