class Person < ActiveRecord::Base
  has_one :user
  has_many :people_book_numbers
  has_many :book_numbers, through: :people_book_numbers
  has_many :relationship_people
  has_many :relationships, through: :relationship_people

  scope :no_gender, -> { where(male: nil) }
  scope :male, -> { where(male: true) }
  scope :female, -> { where(male: false) }

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def self.find_by_kbn(kbn)
    BookNumber.where(kbn: kbn).first.people.first rescue nil
  end

  def parents
    parents = []
    self.relationship_people.where(type: 'RelationshipChild').each do |child_relationship|
      child_relationship.relationship.relationship_people.where(type: 'RelationshipPartner').each do |partner_relationship|
        parents << partner_relationship.person
      end
    end
    parents
  end

  def partners
    partners = []
    self.relationship_people.where(type: 'RelationshipPartner').each do |relationship|
      relationship.relationship.relationship_people.where(type: 'RelationshipPartner').each do |partner_relationship|
        partners << partner_relationship.person if partner_relationship.person_id != self.id
      end
    end
    partners
  end

  def children
    children = []
    self.relationship_people.where(type: 'RelationshipPartner').each do |relationship|
      relationship.relationship.relationship_people.where(type: 'RelationshipChild').each do |child_relationship|
        children << child_relationship.person
      end
    end
    children
  end

  def grandchildren
    count = 0
    self.children.each do |child|
      count = count + child.children.count
    end
    count
  end

  def greatgrandchildren(count, generation)
    self.children.each do |child|
      if generation == 0
        count = count + child.children.count
      else
        count = child.greatgrandchildren(count, generation - 1)
      end
    end
    count
  end

  def descendents
    count = 0
    self.children.each do |child|
      count = count + 1 + child.children.count
    end
    count
  end

  def self.import(csv)
    people = []
    csv.each do |row|
      people << self.import_row(row)
    end
    people
  end

  def self.import_row(row)
    person = Person.find_by_kbn(row['KBN'])
    if person.nil?
      person = Person.create({first_name: row['first_name'], last_name: row['last_name'], male: (row['gender'].blank?)? nil : ((row['gender'] == 'M')? true : false), birth_day: row['birth_day'], birth_place: row['birth_place'], death_day: row['death_day'], death_place: row['death_place']})
      person.import_kbn(row)
    elsif !row['relationship_number'].blank?
      parent = (row['parent_id'].blank?)? Person.find(1) : Person.find_by_kbn(row['parent_id'])
      if !parent.nil?
        partner_relationship = parent.relationship_people.where(type: 'RelationshipPartner').where(order: row['relationship_number']).first
        if !partner_relationship.nil?
          RelationshipChild.create({relationship_id: partner_relationship.relationship.id, person_id: person.id})
        end
      end
    end
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