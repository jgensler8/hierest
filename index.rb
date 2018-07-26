require 'json'
require 'yaml'
require 'git'
require_relative 'hierest'

# read json from stdin
inp = $stdin.read
obj = JSON.parse(inp)

# clone the github repo
repo = obj["repo"]
if not repo
  return 1
end

real_out = $stdout
clone_root = '/tmp/clone'
name = "repo"
$stdout = $stderr
Git.clone(repo, name, :path => clone_root)

# run hierest
# facts = YAML.load_file("./example/facts.yaml")
facts = obj["facts"] || {}

clone_directory = File.absolute_path(clone_root + "/" + name)
hr = HierestThing.new($stdout)
all_lookups = hr.lookup_everything(clone_directory, facts)

# print object to stdout
$stdout = real_out
puts all_lookups
