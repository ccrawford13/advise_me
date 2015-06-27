require "rails_helper"

describe 'Creating student', js: true do
  Capybara.javascript_driver = :webkit
  let(:user) { create(:user, confirmed_at: Time.new(2014)) }
  let(:student) { build(:student) }

  context 'successful student creation' do

    before do
      visit user_path(user)
      create_user_from_form
    end

    it 'flashes success messsage' do
      expect(page).to have_content "Student successfully added"
    end

    it 'adds student to list' do
      expect(page).to have_content student.first_name
    end

    it 'updates student count' do
      expect{create_user_from_form}.to change{user.students.count}.by 1
    end
  end

  context 'unsuccessful student creation' do

    before do
      visit user_path(user)
      click_button "add_student"
    end

    describe 'error feedback messages' do

      it 'requires first name' do
        fill_in "Last name", with: "Student"
        fill_in "Email", with: "bill@example.com"
        fill_in "Year/Status", with: "Senior"
        fill_in "Major", with: "Computer Science"
        click_button "save_student"
        within('.modal') do
          expect(page).to have_content "First name can't be blank"
        end
      end

      it 'requires last name' do
        fill_in "First name", with: "Bill"
        fill_in "Email", with: "bill@example.com"
        fill_in "Year/Status", with: "Senior"
        fill_in "Major", with: "Computer Science"
        click_button "save_student"
        within('.modal') do
          expect(page).to have_content "Last name can't be blank"
        end
      end

      it 'requires email' do
        fill_in "First name", with: "Bill"
        fill_in "Last name", with: "Student"
        fill_in "Year/Status", with: "Senior"
        fill_in "Major", with: "Computer Science"
        click_button "save_student"
        within('.modal') do
          expect(page).to have_content "Email can't be blank"
        end
      end

      it 'requires last name' do
        fill_in "First name", with: "Bill"
        fill_in "Last name", with: "Student"
        fill_in "Email", with: "bill@example.com"
        fill_in "Major", with: "Computer Science"
        click_button "save_student"
        within('.modal') do
          expect(page).to have_content "Year can't be blank"
        end
      end

      it 'requires last name' do
        fill_in "First name", with: "Bill"
        fill_in "Last name", with: "Student"
        fill_in "Email", with: "bill@example.com"
        fill_in "Year/Status", with: "Senior"
        click_button "save_student"
        within('.modal') do
          expect(page).to have_content "Major can't be blank"
        end
      end
    end
  end
end

def create_user_from_form
  click_button "add_student"
  fill_in "First name", with: student.first_name
  fill_in "Last name", with: student.email
  fill_in "Email", with: student.email
  fill_in "Year/Status", with: student.year
  fill_in "Major", with: student.major
  click_button "save_student"
end
