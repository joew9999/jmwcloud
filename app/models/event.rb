class Event < ActiveRecord::Base
  has_many :event_people
  has_many :people, through: :event_people
  has_many :relationship_events
  has_many :relationships, through: :relationship_events
end