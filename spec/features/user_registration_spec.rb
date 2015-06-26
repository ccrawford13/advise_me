require 'rails_helper'

describe 'User registration' do

  before do
    visit root_path
    click_link "sign_up"
  end

  context 'successful sign up' do

    let(:user) { build(:user) }

    before do
      user_sign_up
    end

    it 'flashes email confirmation message' do
      expect(page).to have_content "A message with a confirmation link has been sent"
    end

    it 'redirects user to sign in page' do
      expect(current_path).to eq new_user_session_path
    end
  end

  context 'unsuccessful sign up' do

    describe 'error feedback messages' do

      it "requires first name" do
        fill_in "Last name", with: "Smith"
        fill_in "Position", with: "Advisor"
        fill_in "Organization", with: "Florida"
        fill_in "Email", with: "john@example.com"
        fill_in "Password", with: "helloworld"
        fill_in "Password confirmation", with: "helloworld"
        click_button "sign_up"
        expect( page ).to have_content "First name can't be blank"
      end

      it "requires last name" do
        fill_in "First name", with: "John"
        fill_in "Position", with: "Advisor"
        fill_in "Organization", with: "Florida"
        fill_in "Email", with: "john@example.com"
        fill_in "Password", with: "helloworld"
        fill_in "Password confirmation", with: "helloworld"
        click_button "sign_up"
        expect( page ).to have_content "Last name can't be blank"
      end

      it "requires position" do
        fill_in "First name", with: "John"
        fill_in "Last name", with: "Smith"
        fill_in "Organization", with: "Florida"
        fill_in "Email", with: "john@example.com"
        fill_in "Password", with: "helloworld"
        fill_in "Password confirmation", with: "helloworld"
        click_button "sign_up"
        expect( page ).to have_content "Position can't be blank"
      end

      it "requires organization" do
        fill_in "First name", with: "John"
        fill_in "Last name", with: "Smith"
        fill_in "Position", with: "Advisor"
        fill_in "Email", with: "john@example.com"
        fill_in "Password", with: "helloworld"
        fill_in "Password confirmation", with: "helloworld"
        click_button "sign_up"
        expect( page ).to have_content "Organization can't be blank"
      end

      it "requires valid email" do
        fill_in "First name", with: "John"
        fill_in "Last name", with: "Smith"
        fill_in "Position", with: "Advisor"
        fill_in "Organization", with: "Florida"
        fill_in "Email", with: "john@example"
        fill_in "Password", with: "helloworld"
        fill_in "Password confirmation", with: "helloworld"
        click_button "sign_up"
        expect( page ).to have_content "Email is invalid"
      end

      it "requires valid password" do
        fill_in "First name", with: "John"
        fill_in "Last name", with: "Smith"
        fill_in "Position", with: "Advisor"
        fill_in "Organization", with: "Florida"
        fill_in "Email", with: "john@example.com"
        fill_in "Password", with: "world"
        fill_in "Password confirmation", with: "world"
        click_button "sign_up"
        expect( page ).to have_content "Password is too short"
      end

      it "requires matching passwords" do
        fill_in "First name", with: "John"
        fill_in "Last name", with: "Smith"
        fill_in "Position", with: "Advisor"
        fill_in "Organization", with: "Florida"
        fill_in "Email", with: "john@example.com"
        fill_in "Password", with: "hellowor"
        fill_in "Password confirmation", with: "helloworld"
        click_button "sign_up"
        expect( page ).to have_content "Password confirmation doesn't match Password"
      end
    end
  end
end

def user_sign_up
  fill_in "First name", with: user.first_name
  fill_in "Last name", with: user.last_name
  fill_in "Position", with: user.position
  fill_in "Organization", with: user.organization
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  fill_in "Password confirmation", with: user.password
  click_button "sign_up"
end
