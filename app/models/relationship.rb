class Relationship < ActiveRecord::Base
  has_many :relationship_people
  has_many :people, through: :relationship_people
  has_many :relationship_events
  has_many :events, through: :relationship_events

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
    if !person.nil? && !partner.nil?
      relationship = Relationship.create
      RelationshipPartner.create({relationship_id: relationship.id, person_id: person.id, order: row['order']})
      RelationshipPartner.create({relationship_id: relationship.id, person_id: partner.id, order: partner.relationships.count + 1})
      if !row['married'].blank? && !row['marriage_day'].blank?
        event = Marriage.create({time: row['marriage_day']})
        RelationshipEvent.create({relationship_id: relationship.id, event_id: event.id, order: 1})
      end
    end
    relationship
  end
end
