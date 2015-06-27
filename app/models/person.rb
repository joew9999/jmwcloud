class Person < ActiveRecord::Base
  has_one :user
  has_many :people_book_numbers
  has_many :book_numbers, through: :people_book_numbers
  has_many :events

  scope :no_gender, -> { where(male: nil) }
  scope :male, -> { where(male: true) }
  scope :female, -> { where(male: false) }

  def birth
    self.events.where(type: 'Birth').first_or_create
  end

  def death
    self.events.where(type: 'Death').first_or_create
  end

  def self.import(csv)
    people = []
    csv.each do |row|
      people << self.import_row(row)
    end
    people
  end

  def self.import_row(row)
    person = Person.create({first_name: row['first_name'], last_name: row['last_name'], male: (row['gender'].blank?)? nil : ((row['gender'] == 'M')? true : false)})
    person.import_kbn(row)
    person.birth.update_attributes({time: Chronic.parse(row['birth_day']), location: row['birth_place']})
    person.death.update_attributes({time: Chronic.parse(row['death_day']), location: row['death_place']})
    person
  end

  def import_kbn(row)
    unless self.id.nil?
      unless row['KBN'].blank?
        self.connect_kbn(row['KBN'])
      end
      unless row['KBN2'].blank?
        self.connect_kbn(row['KBN2'])
      end
      unless row['KBN3'].blank?
        self.connect_kbn(row['KBN3'])
      end
    end
  end

  def connect_kbn(kbn)
    book_number = BookNumber.where(kbn: kbn).first_or_create
    PeopleBookNumber.create({book_number_id: book_number.id, person_id: self.id})
  end
end