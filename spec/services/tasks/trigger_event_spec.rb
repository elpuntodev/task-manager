require 'rails_helper'

RSpec.describe Tasks::TriggerEvent do
  let(:task) { build(:task_with_participants, participants_count: 3) }

  subject(:service) { described_class.new }

  describe '#call' do    
    context 'with a valid task' do
      let(:event) { :start }
      before(:each) { task.save }
      it 'should return success' do
        success, message = service.call(task, event)
        expect(success).to be_truthy
        expect(message).to eq('Successfully')
        expect(task.status).to eq('in_progress')
        expect(task.transitions.count).to eq(1)
      end
    end  
  end
end
