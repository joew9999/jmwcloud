class Person < ActiveRecord::Base
  has_one :user

  validates_uniqueness_of :kbn, allow_nil: true

  scope :no_gender, -> { where(male: nil) }
  scope :male, -> { where(male: true) }
  scope :female, -> { where(male: false) }

  def name
    "#{self.first_name} #{self.last_name}"
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
      person = Person.create({kbn: row['KBN'], first_name: row['first_name'], last_name: row['last_name'], male: (row['gender'].blank?)? nil : ((row['gender'] == 'M')? true : false), birth_day: row['birth_day'], birth_place: row['birth_place'], death_day: row['death_day'], death_place: row['death_place']})
    elsif !row['relationship_number'].blank?
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
    person
  end
end