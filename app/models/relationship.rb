class Relationship < ActiveRecord::Base
  has_many :relationship_people
  has_many :people, through: :relationship_people
  has_many :relationship_events
  has_many :events, through: :relationship_events
end
