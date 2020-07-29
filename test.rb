require "test/unit/assertions"
include Test::Unit::Assertions

client = SymbolAnimal.collection.client
client[:animals].find.delete_many

# Create with symbol field

cat = SymbolAnimal.create(species: :cat)
assert_equal :cat, cat.species
assert_equal :cat, cat.attributes["species"]

cat_reloaded = SymbolAnimal.find(cat.id)
assert_equal :cat, cat_reloaded.species
assert_equal :cat, cat_reloaded.attributes[:species]
assert_match /species: :cat/, cat_reloaded.inspect

cat_other = StringAnimal.find(cat.id)
assert_equal "cat", cat_other.species
assert_equal :cat, cat_other.attributes[:species]
assert_match /species: :cat/, cat_other.inspect

cat_other.save!
cat_updated = SymbolAnimal.find(cat.id)
assert_equal :cat, cat_updated.species
assert_equal :cat, cat_updated.attributes[:species]
assert_match /species: :cat/, cat_updated.inspect

assert_equal :cat, client[:animals].find(_id: cat.id).first["species"]
assert_equal 1, client[:animals].find(species: :cat).count
assert_equal 1, client[:animals].find(species: "cat").count

# Create with string field

dog = StringAnimal.create(species: "dog")
assert_equal "dog", dog.species
assert_equal "dog", dog.attributes["species"]

dog_reloaded = StringAnimal.find(dog.id)
assert_equal "dog", dog_reloaded.species
assert_equal "dog", dog_reloaded.attributes[:species]
assert_match /species: "dog"/, dog_reloaded.inspect

dog_other = SymbolAnimal.find(dog.id)
assert_equal :dog, dog_other.species
assert_equal "dog", dog_other.attributes[:species]
assert_match /species: "dog"/, dog_other.inspect

dog_other.save!
dog_updated = StringAnimal.find(dog.id)
assert_equal "dog", dog_updated.species
assert_equal "dog", dog_updated.attributes[:species]
assert_match /species: "dog"/, dog_updated.inspect

assert_equal "dog", client[:animals].find(_id: dog.id).first["species"]
assert_equal 1, client[:animals].find(species: :dog).count
assert_equal 1, client[:animals].find(species: "dog").count

# Update symbol to string

bird = SymbolAnimal.create(species: "bird")
assert_equal :bird, bird.species
assert_equal :bird, bird.attributes["species"]
assert_match /species: :bird/, bird.inspect

bird_other = StringAnimal.find(bird.id)
bird_other.species = "tori"
bird_other.save!
assert_match /species: "tori"/, bird_other.inspect

bird_updated = SymbolAnimal.find(bird.id)
assert_equal :tori, bird_updated.species
assert_equal "tori", bird_updated.attributes[:species]
assert_match /species: "tori"/, bird_updated.inspect

assert_equal "tori", client[:animals].find(_id: bird.id).first["species"]
assert_equal 0, client[:animals].find(species: :bird).count
assert_equal 0, client[:animals].find(species: "bird").count
assert_equal 1, client[:animals].find(species: :tori).count
assert_equal 1, client[:animals].find(species: "tori").count

# Update other field

rabbit = SymbolAnimal.create(species: "rabbit", foo: true)
assert_equal :rabbit, rabbit.species
assert_equal :rabbit, rabbit.attributes["species"]
assert_match /species: :rabbit/, rabbit.inspect

rabbit_other = StringAnimal.find(rabbit.id)
assert_equal "rabbit", rabbit_other.species
assert_equal :rabbit, rabbit_other.attributes[:species]
assert_match /species: :rabbit/, rabbit_other.inspect

rabbit_other.foo = !rabbit_other.foo
rabbit_other.save!

rabbit_updated = SymbolAnimal.find(rabbit.id)
assert_equal :rabbit, rabbit_updated.species
assert_equal :rabbit, rabbit_updated.attributes[:species]
assert_match /species: :rabbit/, rabbit_updated.inspect

assert_equal :rabbit, client[:animals].find(_id: rabbit.id).first["species"]
assert_equal 1, client[:animals].find(species: :rabbit).count
assert_equal 1, client[:animals].find(species: "rabbit").count

# Insert and count with ruby driver

client[:animals].insert_one({ species: "bear", created_at: Time.now })
client[:animals].insert_one({ species: :bear,  created_at: Time.now })
assert_equal 2, client[:animals].find(species: :bear).count
assert_equal 2, client[:animals].find(species: "bear").count

assert_equal :bear, client[:animals].find({}, sort: { created_at: -1 }).first["species"]

# Stringify all inputs / outputs

# for serialization
class Symbol
  def bson_type
    BSON::String::BSON_TYPE
  end
end

# for deserialization
BSON::Registry.register(BSON::Symbol::BSON_TYPE, ::String)

assert_match /species: "cat"/, SymbolAnimal.find(cat.id).inspect
assert_match /species: "dog"/, SymbolAnimal.find(dog.id).inspect
assert_match /species: "tori"/, SymbolAnimal.find(bird.id).inspect
assert_match /species: "rabbit"/, SymbolAnimal.find(rabbit.id).inspect
assert_equal "bear", client[:animals].find({}, sort: { created_at: -1 }).first["species"]
