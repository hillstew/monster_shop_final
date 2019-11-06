require 'rails_helper'

RSpec.describe 'User Registration' do
  describe 'As a Visitor' do
    it 'I see a link to register as a user' do
      visit root_path

      click_link 'Register'

      expect(current_path).to eq(registration_path)
    end

    it 'I can register as a user' do
      visit registration_path

      fill_in :name, with: 'Megan'
      fill_in :street_address, with: '123 Main St'
      fill_in :city, with: 'Denver'
      fill_in :state, with: 'CO'
      fill_in :zip, with: '80218'
      fill_in :email, with: 'megan@example.com'
      fill_in :password, with: 'securepassword'
      fill_in :password_confirmation, with: 'securepassword'
      click_button 'Register'

      expect(current_path).to eq(profile_path)
      expect(page).to have_content('Welcome, Megan!')
    end

    describe 'I can not register as a user if' do
      it 'I do not complete the registration form' do
        visit registration_path

        fill_in :name, with: 'Megan'
        click_button 'Register'

        expect(page).to have_button('Register')
        # expect(page).to have_content("address: [\"can't be blank\"]")
        # expect(page).to have_content("city: [\"can't be blank\"]")
        # expect(page).to have_content("state: [\"can't be blank\"]")
        # expect(page).to have_content("zip: [\"can't be blank\"]")
        expect(page).to have_content("email: [\"can't be blank\"]")
        expect(page).to have_content("password: [\"can't be blank\"]")
      end

      it 'I use a non-unique email' do
        user = User.create(
          name: 'Megan', 
          email: 'megan@example.com', 
          password: 'securepassword'
        )
        address = user.addresses.create(
          address: '123 Main St',
          city: 'Marianna',
          state: 'FL',
          zip: 19863
        )

        visit registration_path

        fill_in :name, with: "megan"
        fill_in :street_address, with: address.address
        fill_in :city, with: address.city
        fill_in :state, with: address.state
        fill_in :zip, with: address.zip
        fill_in :email, with: user.email
        fill_in :password, with: user.password
        fill_in :password_confirmation, with: user.password

        click_button 'Register'

        expect(page).to have_button('Register')
        expect(page).to have_content("email: [\"has already been taken\"]")
      end
    end
  end
end
