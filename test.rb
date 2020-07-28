require "test/unit/assertions"
include Test::Unit::Assertions


# Create with symbol field

cat = SymbolAnimal.create(species: :cat)
assert_equal :cat, cat.species

cat_reloaded = SymbolAnimal.find(cat.id)
assert_equal :cat, cat_reloaded.species

cat_other = StringAnimal.find(cat.id)
assert_equal "cat", cat_other.species

cat_other.save!
assert_equal :cat, SymbolAnimal.find(cat.id).species

# Create with string field

dog = StringAnimal.create(species: "dog")
assert_equal "dog", dog.species

dog_reloaded = StringAnimal.find(dog.id)
assert_equal "dog", dog_reloaded.species

dog_other = SymbolAnimal.find(dog.id)
assert_equal :dog, dog_other.species

dog_other.save!
assert_equal "dog", StringAnimal.find(dog.id).species
