class Relationship < ActiveRecord::Base
  def self.import(csv)
    relationships = []
    csv.each do |row|
      relationships << self.import_row(row) if !row['KBN'].blank? && !row['order'].blank?
    end
    relationships
  end

  def self.import_row(row)
    relationship = nil
    person = Person.find_by_kbn(row['KBN'])
    partner = Person.where(first_name: row['first_name']).where(last_name: row['last_name']).first_or_create
    partner.update_attributes({birth_day: row['birth_day'], death_day: row['death_day']})
    if !person.nil? && !partner.nil?
      relationship = Relationship.create
      relationship.partner_ids << person.id
      relationship.partner_ids << partner.id
      relationship.marriage_day = row['marriage_day'] if !row['married'].blank? && !row['marriage_day'].blank?
      relationship.divorce_day = row['divorce_day'] if row['married'] == '**'
      relationship.partner_ids_will_change!
      relationship.save
      person.relationship_ids << relationship.id
      person.relationship_ids_will_change!
      person.save
      partner.relationship_ids << relationship.id
      partner.relationship_ids_will_change!
      partner.save
    end
    relationship
  end
end
