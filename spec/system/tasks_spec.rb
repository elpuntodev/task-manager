require 'rails_helper'

RSpec.describe "Tasks", type: :system do # Using capybara
  let(:user) { create(:user) }
  before(:each) { sign_in user }

  describe 'GET /tasks' do
    it 'has a correct title' do
      visit tasks_path
      expect(page).to have_content 'Lista de Tareas'  
    end
  end

  describe 'POST /tasks/new' do
    let!(:category) { create(:category) }
    let!(:participant) { create(:user) }

    it 'has a correct title', js: true do
      visit new_task_path
      fill_in('task[name]', with: Faker::Lorem.sentence)
      fill_in('task[description]', with: Faker::Lorem.paragraph)
      fill_in('task[due_date]', with: Date.today + 5.day)
      # select(category.name, from: 'task[category_id]')
      page.execute_script(
        "document.getElementById('task_category_id').selectize.setValue('#{category.id}')"
    )

      click_link('Agregar un participante')
      # within(:xpath, '//*[@id="new_task"]/div[1]/div[4]/div[1]') do
      #   select participant.email, from: 'Usuario'
      #   select 'follower', from: 'Rol'
      # end
      page.execute_script(
        "document.querySelector('.selectize.responsible').selectize.setValue('#{participant.id}')"
      )
      page.execute_script(
        "document.querySelector('.selectize.role').selectize.setValue('1')"
      )
      click_button('Crear Task')

      expect(page).to have_content 'Task was successfully created.'
    end
  end
end
