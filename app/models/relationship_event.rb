class RelationshipEvent < ActiveRecord::Base
  belongs_to :relationship
  belongs_to :event

  default_scope { order(order: :asc) }
end
