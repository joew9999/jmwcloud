class PeopleBookNumber < ActiveRecord::Base
  belongs_to :person
  belongs_to :book_number

  validates :person_id, presence: true
  validates :book_number_id, presence: true, uniqueness: true
end
