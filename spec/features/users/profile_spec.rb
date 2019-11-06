require 'rails_helper'

RSpec.describe "User Profile Path" do
  describe "As a registered user" do
    before :each do
      @user = User.create!(name: 'Megan', email: 'megan@example.com', password: 'securepassword')
      @address = @user.addresses.create(nickname: "home", address: "123 erie rd", city: "hi", state: "FL", zip: 98089)
      @admin = User.create!(name: 'Megan', email: 'admin@example.com', password: 'securepassword')
    end

    it "I can view my profile page" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit profile_path

      expect(page).to have_content(@user.name)
      expect(page).to have_content(@user.email)
      expect(page).to have_content(@address.nickname)
      expect(page).to have_content(@address.address)
      expect(page).to have_content("#{@address.city}, #{@address.state} #{@address.zip}")
      expect(page).to_not have_content(@user.password)
      expect(page).to have_link('Edit')
    end

    it "I can update my profile name and email" do
      visit login_path

      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_button 'Log In'

      click_link 'Edit'

      expect(current_path).to eq('/profile/edit')

      name = 'New Name'
      email = 'new@example.com'

      fill_in :name, with: name
      fill_in :email, with: email

      click_button 'Update Profile'

      expect(current_path).to eq(profile_path)

      expect(page).to have_content('Profile has been updated!')
      expect(page).to have_content(name)
      expect(page).to have_content(email)
    end

    it "I can update my password" do
      visit login_path

      fill_in :email, with: @user.email
      fill_in :password, with: @user.password
      click_button 'Log In'

      click_link 'Change Password'

      expect(current_path).to eq('/profile/edit_password')

      password = "newpassword"

      fill_in "Password", with: password
      fill_in "Password confirmation", with: password
      click_button 'Change Password'

      expect(current_path).to eq(profile_path)

      expect(page).to have_content('Profile has been updated!')

      click_link 'Log Out'

      visit login_path

      fill_in :email, with: @user.email
      fill_in :password, with: @user.password
      click_button 'Log In'

      expect(page).to have_content("Your email or password was incorrect!")

      visit login_path

      fill_in :email, with: @user.email
      fill_in :password, with: "newpassword"
      click_button 'Log In'

      expect(current_path).to eq(profile_path)
    end

    it "I must use a unique email address" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit '/profile/edit'

      fill_in :email, with: @admin.email
      click_button "Update Profile"

      expect(page).to have_content("email: [\"has already been taken\"]")
      expect(page).to have_button "Update Profile"
    end

    it "I can add a new shipping address" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit '/profile'

      click_link "Add new address"
      
      expect(current_path).to eq("/profile/addresses")

      fill_in :nickname, with: "Mom"
      fill_in :address, with: "123 Rust St"
      fill_in :city, with: "Sunbelt"
      fill_in :state, with: "Ocala"
      fill_in :zip, with: 34567

      click_button "Add Address"

      expect(current_path).to eq("/profile")

      address = Address.last

      within "#address-#{address.id}" do
        expect(page).to have_content("Mom")
        expect(page).to have_content("123 Rust St")
        expect(page).to have_content("Sunbelt, Ocala 34567")
        expect(page).to have_button("Edit")
        expect(page).to have_button("Delete")
      end
    end
  end
end
