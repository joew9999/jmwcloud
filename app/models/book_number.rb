class BookNumber < ActiveRecord::Base
  has_many :people_book_numbers
  has_many :people, through: :people_book_numbers

  validates :kbn, presence: true, uniqueness: true
end
