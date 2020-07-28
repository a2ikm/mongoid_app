require "test/unit/assertions"
include Test::Unit::Assertions


# Create with symbol field

cat = SymbolAnimal.create(species: :cat)
assert_equal :cat, cat.species

cat_reloaded = SymbolAnimal.find(cat.id)
assert_equal :cat, cat_reloaded.species
assert_match /species: :cat/, cat_reloaded.inspect

cat_other = StringAnimal.find(cat.id)
assert_equal "cat", cat_other.species
assert_match /species: :cat/, cat_other.inspect

cat_other.save!
cat_updated = SymbolAnimal.find(cat.id)
assert_equal :cat, cat_updated.species
assert_match /species: :cat/, cat_updated.inspect

# Create with string field

dog = StringAnimal.create(species: "dog")
assert_equal "dog", dog.species

dog_reloaded = StringAnimal.find(dog.id)
assert_equal "dog", dog_reloaded.species
assert_match /species: "dog"/, dog_reloaded.inspect

dog_other = SymbolAnimal.find(dog.id)
assert_equal :dog, dog_other.species
assert_match /species: "dog"/, dog_other.inspect

dog_other.save!
dog_updated = StringAnimal.find(dog.id)
assert_equal "dog", dog_updated.species
assert_match /species: "dog"/, dog_updated.inspect

# Update symbol to string

bird = SymbolAnimal.create(species: "bird")
assert_equal :bird, bird.species
assert_match /species: :bird/, bird.inspect

bird_other = StringAnimal.find(bird.id)
bird_other.species = "tori"
bird_other.save!
assert_match /species: "tori"/, bird_other.inspect

bird_updated = SymbolAnimal.find(bird.id)
assert_equal :tori, bird_updated.species
assert_match /species: "tori"/, bird_updated.inspect
