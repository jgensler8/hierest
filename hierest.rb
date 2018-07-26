# require 'rubygems'
require 'hiera'
require 'yaml'
require 'logger'


class HierestThing
  def initialize(log_stream)
    @logger = Logger.new(log_stream)
    @logger.level = Logger::DEBUG
  end

  # crawl_hiera_directory crawls a directory to json and yaml files and returns the resulting files in a list.
  # All paths are returned as complete paths (not relative)
  #
  # ==== Attributes
  #
  # * +directory+ - Directory to start the search in.
  #
  # ==== Examples
  #
  # Illustrate the behaviour of the method using examples. Indent examples:
  #
  #    base = Base.new("./example/common")
  #    base.method_name("Example", "more")
  def crawl_hiera_directory(directory)
    files = []
    Dir[directory + '/**/*.yaml'].each { |f| files << File.absolute_path(f) }
    return files
  end

  # get_root_keys_from_file returns the root keys of a YAML file
  #
  # ==== Attributes
  #
  # * +file+ - absolute path to a YAML file
  #
  # ==== Examples
  #
  # Illustrate the behaviour of the method using examples. Indent examples:
  #
  #    base = Base.new("./example/common")
  #    base.method_name("Example", "more")
  def get_root_keys_from_file(file)
    @logger.debug("Getting Root Keys fromt %s" % file)
    keys = []
    y = YAML.load_file(file)
    y.each{ |k,v| keys << k }
    return keys
  end

  # get_root_keys_from_file returns the root keys of a YAML file
  #
  # ==== Attributes
  #
  # * +file+ - absolute path to a YAML file
  #
  # ==== Examples
  #
  # Illustrate the behaviour of the method using examples. Indent examples:
  #
  #    base = Base.new("./example/common")
  #    base.method_name("Example", "more")
  def get_root_keys_from_directory(directory)
    @logger.debug("Getting Root Keys in %s" % directory)
    keys = []
    crawl_hiera_directory(directory).each{ |f|
      @logger.debug("Found file %s" % f)
      get_root_keys_from_file(f).each{ |k| keys << k }
    }
    return keys
  end

  def lookup_everything(clone_directory, facts)
    @logger.info("Looking up everything in %s" % clone_directory)
    hiera_file = File.join(clone_directory, "hiera.yaml")
    h = YAML.load_file(hiera_file)
    datadir = File.join(clone_directory, h[:yaml][:datadir])
    h[:yaml][:datadir] = datadir
    hiera = Hiera.new(:config => h)
    config = {}
    @logger.debug("Looking for root keys in %s" % datadir)
    get_root_keys_from_directory(datadir).each{ |v|
      @logger.debug("Root Key: %s" % v)
      config[v] = hiera.lookup(v, nil, facts)
    }
    return config
  end

end
