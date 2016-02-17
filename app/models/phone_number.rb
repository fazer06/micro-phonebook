# == Schema Information
#
# Table name: phone_numbers
#
#  id           :integer          not null, primary key
#  number       :string
#  contact_id   :integer
#  contact_type :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_phone_numbers_on_contact_id  (contact_id)
#

class PhoneNumber < ActiveRecord::Base

	belongs_to :contact, polymorphic: true

end
