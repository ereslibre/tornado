module Tornado

  class Config

    @@config = nil
    @@config_loaded = false

    def self.trusted_peers
      load_config
      @@config['trusted_peers']
    end

    private

    def self.load_config
      return if @@config_loaded
      @@config = YAML.load_file(File.expand_path("#{File.dirname(__FILE__)}/../config/config.yml"))
      @@config_loaded = true
    end

  end

end