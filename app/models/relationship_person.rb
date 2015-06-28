class RelationshipPerson < ActiveRecord::Base
  belongs_to :relationship
  belongs_to :person

  default_scope { order(order: :asc) }
end
