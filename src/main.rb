require 'yaml'
require_relative 'hierest'


facts = YAML.load_file("./example/facts.yaml")

clone_directory = File.absolute_path("./example")
hr = HierestThing.new()
all_lookups = hr.lookup_everything(clone_directory, facts)

puts all_lookups
