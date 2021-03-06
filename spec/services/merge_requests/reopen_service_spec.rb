require 'spec_helper'

describe MergeRequests::ReopenService, services: true do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:guest) { create(:user) }
  let(:merge_request) { create(:merge_request, :closed, assignee: user2) }
  let(:project) { merge_request.project }

  before do
    project.team << [user, :master]
    project.team << [user2, :developer]
    project.team << [guest, :guest]
  end

  describe '#execute' do
    context 'valid params' do
      let(:service) { described_class.new(project, user, {}) }

      before do
        allow(service).to receive(:execute_hooks)

        perform_enqueued_jobs do
          service.execute(merge_request)
        end
      end

      it { expect(merge_request).to be_valid }
      it { expect(merge_request).to be_reopened }

      it 'executes hooks with reopen action' do
        expect(service).to have_received(:execute_hooks).
                               with(merge_request, 'reopen')
      end

      it 'sends email to user2 about reopen of merge_request' do
        email = ActionMailer::Base.deliveries.last
        expect(email.to.first).to eq(user2.email)
        expect(email.subject).to include(merge_request.title)
      end

      it 'creates system note about merge_request reopen' do
        note = merge_request.notes.last
        expect(note.note).to include '状态已更改为重新打开'
      end
    end

    context 'current user is not authorized to reopen merge request' do
      before do
        perform_enqueued_jobs do
          @merge_request = described_class.new(project, guest).execute(merge_request)
        end
      end

      it 'does not reopen the merge request' do
        expect(@merge_request).to be_closed
      end
    end
  end
end
