require 'rails_helper'

RSpec.describe "Address Edit page" do
  it "I should be able to edit my existing addresses" do
    @m_user = User.create(name: 'Megan', email: 'megan@example.com', password: 'securepassword')
    @b_user = User.create(name: 'Brian', email: 'brian@example.com', password: 'securepassword')
    @address_m1 = @m_user.addresses.create(nickname: "work", address: '123 Main St', city: 'Marianna', state: 'Florida', zip: 12345)
    @address_m2 = @m_user.addresses.create(nickname: "work", address: '123 Main St', city: 'Portland', state: 'Oregon', zip: 34267)
    @address_b1 = @b_user.addresses.create(nickname: "work", address: '123 Main St', city: 'Austin', state: 'Texas', zip: 34567)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    
    visit '/profile'

    within "#address-#{@address_m1.id}" do
      expect(page).to have_content(@address_m1.address)
      expect(page).to have_content("Marianna, Florida 12345")
      click_button "Edit"
    end

    expect(current_path).to eq("/profile/addresses/#{@address_m1.id}")
    
    fill_in :state, with: "Colorado" 

    click_button "Update Address"
    expect(current_path).to eq("/profile")

    within "#address-#{@address_m1.id}" do
      expect(page).to have_content(@address_m1.address)
      expect(page).to have_content("Marianna, Colorado 12345")
    end

    within "#address-#{@address_m2.id}" do
      expect(page).to have_content(@address_m2.address)
      expect(page).to have_content("Portland, Oregon 34267")
    end

    expect(page).to_not have_css("#address-#{@address_b1.id}")
  end
end
