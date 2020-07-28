class StringAnimal
  include Mongoid::Document
  store_in collection: 'animals'

  include Mongoid::Timestamps
  field :species, type: String
  field :foo,     type: Boolean
end
