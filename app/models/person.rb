class Person < ActiveRecord::Base
  has_one :user

  scope :no_gender, -> { where(male: nil) }
  scope :male, -> { where(male: true) }
  scope :female, -> { where(male: false) }

  def self.find_by_kbn(kbn)
    Person.where("kbns @> '{#{kbn}}'").first
  end

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def relationships
    Relationship.where(id: self.relationship_ids)
  end

  def parents
    parents = []
    Relationship.where("'#{self.id}' = ANY (children_ids)").each do |relationship|
      Person.where(id: relationship.partner_ids).each do |parent|
        parents << parent
      end
    end
    parents
  end

  def partners
    partners = []
    Relationship.where("'#{self.id}' = ANY (partner_ids)").each do |relationship|
      Person.where(id: relationship.partner_ids).where.not(id: self.id).each do |partner|
        partners << partner
      end
    end
    partners
  end

  def children
    Person.where(id: self.children_ids)
  end

  def descendents
    people = []
    if self.kbns.first == '0'
      people = Person.where("kbns IS NOT NULL").where("kbns != ''").where.not(id: self.id)
    else
      people = Person.where("ancestors @> '{#{self.kbns.first}}'").where.not(id: self.id)
    end
    people
  end

  def greatgrandchildren(generation)
    people = []
    char_count = self.kbn.size + generation
    if self.kbns.first == '0'
      people = Person.where("kbns IS NOT NULL").where.not(kbns: '0').where.not(kbns: '').where("generations @> '{#{generation}}'")
    else
      people = Person.where("ancestors @> '{#{self.kbns.first}}'").where("kbns IS NOT NULL").where.not(kbns: '').where("generations @> '{#{char_count}}'")
    end
    people
  end

  def self.import(csv)
    csv.each do |row|
      (1..8).to_a.each do |generation|
        self.import_row(row, generation)
      end
    end
  end

  def self.import_row(row, generation)
    if row['first_name'].present?
      self.import_person(row, generation)
    else
      self.import_child(row)
    end
  end

  def update_parents_descendants(new_kbn, child_kbn, generation)
    parent_kbn = (child_kbn.length > 1)? child_kbn[0..-2] : '0'
    parent = Person.find_by_kbn(parent_kbn)
    if generation == 1 && !parent.first_generation.include?(new_kbn)
      parent.first_generation << new_kbn
      parent.first_generation_will_change!
    elsif generation == 2 && !parent.second_generation.include?(new_kbn)
      parent.second_generation << new_kbn
      parent.second_generation_will_change!
    elsif generation == 3 && !parent.third_generation.include?(new_kbn)
      parent.third_generation << new_kbn
      parent.third_generation_will_change!
    elsif generation == 4 && !parent.fourth_generation.include?(new_kbn)
      parent.fourth_generation << new_kbn
      parent.fourth_generation_will_change!
    elsif generation == 5 && !parent.fifth_generation.include?(new_kbn)
      parent.fifth_generation << new_kbn
      parent.fifth_generation_will_change!
    elsif generation == 6 && !parent.sixth_generation.include?(new_kbn)
      parent.sixth_generation << new_kbn
      parent.sixth_generation_will_change!
    elsif generation == 7 && !parent.seventh_generation.include?(new_kbn)
      parent.seventh_generation << new_kbn
      parent.seventh_generation_will_change!
    elsif generation == 8 && !parent.eighth_generation.include?(new_kbn)
      parent.eighth_generation << new_kbn
      parent.eighth_generation_will_change!
    end
    parent.save
    parent.update_parents_descendants(new_kbn, parent_kbn, generation + 1) if parent_kbn != '0'
  end

  def self.import_row(row, generation)
    if generation == 0 || row['KBN'].length == generation
      person = Person.find_by_kbn(row['KBN'])
      kbns = []
      kbns << row['KBN'] if row['KBN'].present?
      kbns << row['KBN1'] if row['KBN1'].present?
      kbns << row['KBN2'] if row['KBN2'].present?
      person_values = {kbns: kbns, first_name: row['first_name'], last_names: [row['last_name']], male: (row['gender'].blank?)? nil : ((row['gender'] == 'M')? true : false), birth_day: row['birth_day'], birth_place: row['birth_place'], death_day: row['death_day'], death_place: row['death_place']}
      if person.nil?
        person = Person.create(person_values)
      else
        person.update_attributes(person_values)
      end
      if generation != 0
        kbns.each do |kbn|
          person.update_parents_descendants(kbn, kbn, 1)
        end
      end
    end
  end

  def self.import_child(row)
    person = Person.find_by_kbn(row['KBN'])
    parent = (row['parent_id'].blank?)? Person.find(1) : Person.find_by_kbn(row['parent_id'])
    if !parent.nil?
      relationship = Relationship.find(parent.relationship_ids[(row['relationship_number'].to_i - 1)]) rescue nil
      if !relationship.nil?
        relationship.children_ids << person.id
        relationship.children_ids_will_change!
        relationship.save
      end
      parent.children_ids << person.id
      parent.children_ids_will_change!
      parent.save
    end
  end
end