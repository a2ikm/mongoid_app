class SymbolAnimal
  include Mongoid::Document
  store_in collection: 'animals'

  include Mongoid::Timestamps
  field :species, type: Symbol
  field :foo,     type: Boolean
end
