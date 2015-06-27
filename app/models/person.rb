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
    person = Person.create({first_name: row['first_name'], last_name: row['last_name']})
    unless person.id.nil?
      unless row['KBN'].blank?
        person.connect_kbn(row['KBN'])
      end
      unless row['KBN2'].blank?
        person.connect_kbn(row['KBN2'])
      end
      unless row['KBN3'].blank?
        person.connect_kbn(row['KBN3'])
      end
    end
    person
  end

  def connect_kbn(kbn)
    book_number = BookNumber.where(kbn: kbn).first_or_create
    PeopleBookNumber.create({book_number_id: book_number.id, person_id: self.id})
  end
end