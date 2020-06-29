class Plane
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :airport, :class_name => 'Airport'

  # embedded_in :airport

  field :name, type:String
  field :status, type:String
end
