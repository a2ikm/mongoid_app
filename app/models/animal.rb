class Animal
  include Mongoid::Document
  include Mongoid::Timestamps
  field :species, type: Symbol
end
