class AnotherAnimal
  include Mongoid::Document
  store_in collection: 'animals'

  include Mongoid::Timestamps
  field :species, type: String
end
