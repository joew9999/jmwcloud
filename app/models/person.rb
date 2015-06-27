class Person < ActiveRecord::Base
  has_one :user
  has_many :people_book_numbers
  has_many :book_numbers, through: :people_book_numbers

  def self.import(csv)
    people = []
    csv.each do |row|
      people << self.import_row(row)
    end
    people
  end

  def self.import_row(row)
    Person.create({first_name: row['first_name'], last_name: row['last_name']})
  end
end