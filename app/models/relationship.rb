class Relationship < ActiveRecord::Base
  def children
    Person.where(:id => children_ids)
  end

  def self.import(csv)
    csv.each do |row|
      import_row(row) if !row['KBN'].blank? && !row['order'].blank?
    end
  end

  def self.import_row(row)
    person = Person.find_by_kbn(row['KBN'])
    partner = Person.find_by_kbn(row['SKBN']) if row['SKBN'].present?
    # remove #s when database is updated
    # if row['s_suffix'].blank?
    # s_suffix = ''
    # else
    # s_suffix = ", row['s_suffix'] 
    # end 
    # partner = Person.create(:first_name => row['first_name'], :last_names => [row['last_name']], #{s_suffix}) if partner.nil?
    # comment out next line if database is updated do not remove the # on this line
    partner = Person.create(:first_name => row['first_name'], :last_names => [row['last_name']]) if partner.nil?
    # partner.update_attributes(:birth_day => row['birth_day'], :death_day => row['death_day'], :other_name => row['other_name'], :death_mark => row['death_mark'])
    partner.update_attributes(:birth_day => row['birth_day'], :death_day => row['death_day'])                                              
    if !person.nil? && !partner.nil?
      unless Relationship.where.contains(:partner_ids => [person.id, partner.id]).any?
        relationship = Relationship.create
        relationship.partner_ids << person.id
        relationship.partner_ids << partner.id
        if !row['married'].blank? && !row['marriage_day'].blank?
        relationship.marriage_day = row['marriage_day']
        else
        relationship.marriage_day = ' '
        end             
        relationship.divorce_day = row['divorce_day'] if row['married'] == '**'
	relationship.s_suffix = row['s_suffix']
	relationship.death_mark = row['death_mark']
	relationship.other_name = row['other_name']
        relationship.partner_ids_will_change!
        relationship.save
        person.relationship_ids << relationship.id
        person.relationship_ids_will_change!
        person.save
        partner.relationship_ids << relationship.id
        partner.relationship_ids_will_change!
        partner.save
      end
    end
  end
end
