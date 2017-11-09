require 'json'

module Tanuki
  module Universe
    class Config

      attr_reader :endpoints

      def initialize(config_path)
        @config_path = config_path
        parse_config_file
      end

      def parse_config_file
        parsed_config = {}
        File.open(@config_path) do |file|
          parsed_config = JSON.load(file)
        end
        global_config(parsed_config)
      end

      def global_config(config)
        @endpoints = config['endpoints']
        #@build_interval = config['build_interval']
      end
    end
  end
end
