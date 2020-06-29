class Airport
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  # embeds_many :planes
  # accepts_nested_attributes_for :planes

  has_many :planes, class_name: 'Plane', inverse_of: :airport, autosave: true, dependent: :delete_all
  accepts_nested_attributes_for :planes, allow_destroy: true


  
end
