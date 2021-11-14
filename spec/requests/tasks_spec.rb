require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  let(:user) { create(:user) }
  before(:each) { sign_in user } # Devise helper
  describe "GET /tasks" do
    it "works! (now write some real specs)" do
      get tasks_path
      expect(response).to have_http_status(200)
    end
  end
  describe 'GET /task/new' do
    it "works! (now write some real specs)" do
      get new_task_path
      expect(response).to render_template(:new)
    end
  end
  describe 'POST /task' do
    let(:category) { create(:category) }
    let(:participant_user) { create(:user) }
    let(:params) do
      {
        task: {
          name: Faker::Lorem.sentence,
          due_date: Date.today + 1.week,
          category_id: category.id.to_s,
          description: Faker::Lorem.paragraph,
          participating_users_attributes: [
            {
              user_id: participant_user.id.to_s,
              role: '1',
              _destroy: false
            }
          ]
        }
      }
    end

    it 'create a new task and redirect to show page' do
      post tasks_path, params: params

      expect(response).to redirect_to(assigns(:task)) # assigns(:task) is a task object instance created in the life of the request. 'assigns' method is available in test type: request.
      follow_redirect!
      expect(response).to render_template(:show)
      expect(response.body).to include('Task was successfully created.')
    end
  end
  describe 'PATCH /tasks/:id/trigger' do
    subject(:task) { build(:task_with_participants, owner: user, participants_count: 3) }
    let(:event) { 'start' }
    it 'updates the state' do
      task.save

      patch trigger_task_path(task, params: { event: event })

      expect(task.reload.status).to eq('in_progress')
    end
  end
end
