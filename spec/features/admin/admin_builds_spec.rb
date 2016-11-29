require 'spec_helper'

describe 'Admin Builds' do
  before do
    login_as :admin
  end

  describe 'GET /admin/builds' do
    let(:pipeline) { create(:ci_pipeline) }

    context 'All tab' do
      context 'when have builds' do
        it 'shows all builds' do
          create(:ci_build, pipeline: pipeline, status: :pending)
          create(:ci_build, pipeline: pipeline, status: :running)
          create(:ci_build, pipeline: pipeline, status: :success)
          create(:ci_build, pipeline: pipeline, status: :failed)

          visit admin_builds_path

          expect(page).to have_selector('.nav-links li.active', text: '所有')
          expect(page).to have_selector('.row-content-block', text: '所有构建')
          expect(page.all('.build-link').size).to eq(4)
          expect(page).to have_link '全部取消'
        end
      end

      context 'when have no builds' do
        it 'shows a message' do
          visit admin_builds_path

          expect(page).to have_selector('.nav-links li.active', text: '所有')
          expect(page).to have_content '没有构建显示'
          expect(page).not_to have_link '全部取消'
        end
      end
    end

    context 'Pending tab' do
      context 'when have pending builds' do
        it 'shows pending builds' do
          build1 = create(:ci_build, pipeline: pipeline, status: :pending)
          build2 = create(:ci_build, pipeline: pipeline, status: :running)
          build3 = create(:ci_build, pipeline: pipeline, status: :success)
          build4 = create(:ci_build, pipeline: pipeline, status: :failed)

          visit admin_builds_path(scope: :pending)

          expect(page).to have_selector('.nav-links li.active', text: '待定')
          expect(page.find('.build-link')).to have_content(build1.id)
          expect(page.find('.build-link')).not_to have_content(build2.id)
          expect(page.find('.build-link')).not_to have_content(build3.id)
          expect(page.find('.build-link')).not_to have_content(build4.id)
          expect(page).to have_link '全部取消'
        end
      end

      context 'when have no builds pending' do
        it 'shows a message' do
          create(:ci_build, pipeline: pipeline, status: :success)

          visit admin_builds_path(scope: :pending)

          expect(page).to have_selector('.nav-links li.active', text: '待定')
          expect(page).to have_content '没有构建显示'
          expect(page).not_to have_link '全部取消'
        end
      end
    end

    context 'Running tab' do
      context 'when have running builds' do
        it 'shows running builds' do
          build1 = create(:ci_build, pipeline: pipeline, status: :running)
          build2 = create(:ci_build, pipeline: pipeline, status: :success)
          build3 = create(:ci_build, pipeline: pipeline, status: :failed)
          build4 = create(:ci_build, pipeline: pipeline, status: :pending)

          visit admin_builds_path(scope: :running)

          expect(page).to have_selector('.nav-links li.active', text: '运行')
          expect(page.find('.build-link')).to have_content(build1.id)
          expect(page.find('.build-link')).not_to have_content(build2.id)
          expect(page.find('.build-link')).not_to have_content(build3.id)
          expect(page.find('.build-link')).not_to have_content(build4.id)
          expect(page).to have_link '全部取消'
        end
      end

      context 'when have no builds running' do
        it 'shows a message' do
          create(:ci_build, pipeline: pipeline, status: :success)

          visit admin_builds_path(scope: :running)

          expect(page).to have_selector('.nav-links li.active', text: '运行')
          expect(page).to have_content '没有构建显示'
          expect(page).not_to have_link '全部取消'
        end
      end
    end

    context 'Finished tab' do
      context 'when have finished builds' do
        it 'shows finished builds' do
          build1 = create(:ci_build, pipeline: pipeline, status: :pending)
          build2 = create(:ci_build, pipeline: pipeline, status: :running)
          build3 = create(:ci_build, pipeline: pipeline, status: :success)

          visit admin_builds_path(scope: :finished)

          expect(page).to have_selector('.nav-links li.active', text: '完成')
          expect(page.find('.build-link')).not_to have_content(build1.id)
          expect(page.find('.build-link')).not_to have_content(build2.id)
          expect(page.find('.build-link')).to have_content(build3.id)
          expect(page).to have_link '全部取消'
        end
      end

      context 'when have no builds finished' do
        it 'shows a message' do
          create(:ci_build, pipeline: pipeline, status: :running)

          visit admin_builds_path(scope: :finished)

          expect(page).to have_selector('.nav-links li.active', text: '完成')
          expect(page).to have_content '没有构建显示'
          expect(page).to have_link '全部取消'
        end
      end
    end
  end
end
