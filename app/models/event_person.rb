class EventPerson < ActiveRecord::Base
  belongs_to :person
  belongs_to :event

  validates :person_id, presence: true
  validates :event_id, presence: true
end