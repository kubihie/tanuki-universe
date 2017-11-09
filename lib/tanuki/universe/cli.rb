require 'thor'

require 'tanuki/universe'
require 'tanuki/universe/version'
require 'tanuki/universe/commands/generate'

module Tanuki
  module Universe
    class Cli < Thor
      include Thor::Actions
  
      DEFAULT_CONFIG = './config.json'
  
      desc 'version', 'Display tanuki-universe version.'
      def version
        puts Tanuki::Universe::VERSION
      end
  
      desc 'generate', 'Generate universe file.'
      method_option :config, aliases: '-c', default: DEFAULT_CONFIG
      def generate
        Tanuki::Universe::Commands::Generate.new(options['config'])
      end

    end

  end
end
