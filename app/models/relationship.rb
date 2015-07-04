class Relationship < ActiveRecord::Base
  has_many :relationship_people
  has_many :people, through: :relationship_people

  def self.import(csv)
    relationships = []
    csv.each do |row|
      relationships << self.import_row(row) if !row['KBN'].blank? && !row['order'].blank?
    end
    relationships
  end

  def self.import_row(row)
    relationship = []
    person = Person.find_by_kbn(row['KBN'])
    partner = Person.where(first_name: row['first_name']).where(last_name: row['last_name']).first_or_create
    partner.update_attributes({birth_day: row['birth_day'], death_day: row['death_day']})
    if !person.nil? && !partner.nil?
      relationship = Relationship.create
      RelationshipPartner.create({relationship_id: relationship.id, person_id: person.id, order: row['order']})
      RelationshipPartner.create({relationship_id: relationship.id, person_id: partner.id, order: partner.relationships.count + 1})
      relationship.update_attributes({marriage_day: row['marriage_day']}) if !row['married'].blank? && !row['marriage_day'].blank?
      relationship.update_attributes({divorce_day: row['divorce_day']}) if row['married'] == '**'
    end
    relationship
  end
end
