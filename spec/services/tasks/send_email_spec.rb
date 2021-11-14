require 'rails_helper'

RSpec.describe Tasks::SendEmail do
  let(:task) { build(:task_with_participants, participants_count: 3) }

  subject(:service) { described_class.new } # described_class is the class we are testing(Tasks::SendEmail)

  describe '#call' do    
    context 'with a valid task' do
      before(:each) { task.save }
      it 'should return success' do
        success, message = service.call(task) # call the method. Interface commmon to use all services.
        expect(success).to be_truthy
        expect(message).to eq('Email sent successfully')
      end
    end
  
    context 'with an invalid task' do
      it 'should return failure' do
        success, message = service.call(nil)
        expect(success).to be_falsey
        expect(message).to eq('Fail sending email')
      end
    end
  end
end
