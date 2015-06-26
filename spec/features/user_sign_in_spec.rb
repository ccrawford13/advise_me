require 'rails_helper'

describe 'User sign in' do

  let(:user) { create(:user, confirmed_at: Time.new(2014)) }

  before do
    visit root_path
    click_link "sign_in"
  end

  context 'successful sign in' do

    before do
      user_sign_in
    end

    it 'flashes success message' do
      expect(page).to have_content "Signed in successfully"
    end

    it 'redirects user to users#show' do
      expect(current_path).to eq user_path(user)
    end
  end

  context 'unsuccessful sign in' do

    describe 'error feedback messages' do

      it 'requires email' do
        fill_in "Password", with: user.password
        click_button "sign_in"
        expect( page ).to have_content "Invalid email or password"
      end

      it 'requires password' do
        fill_in "Email", with: user.email
        click_button "sign_in"
        expect( page ).to have_content "Invalid email or password"
      end

      it 'requires correct password' do
        fill_in "Email", with: user.email
        fill_in "Password", with: "notuserpassword"
        click_button "sign_in"
        expect( page ).to have_content "Invalid email or password"
      end
    end
  end
end

def user_sign_in
  click_link "sign_in"
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "sign_in"
end
