class Address < ApplicationRecord
  validates_presence_of :nickname,
                        :address,
                        :city,
                        :state,
                        :zip

  belongs_to :user
  has_many :orders

  def has_orders?
    orders.where(status: 'shipped').any?
  end
end