require 'json'
require 'gitlab'

require 'tanuki/universe/gitlab_client'
require 'tanuki/universe/config'

module Tanuki
  module Universe
    module Commands
      class Generate
  
        def initialize(config_file)
          config = Tanuki::Universe::Config.new(config_file)

          config.endpoints.each do |endpoint|
            case endpoint['type']
            when 'gitlab' then type_gitlab(endpoint)
            end
          end
        end

        def type_gitlab(endpoint)
          universe = {}

          gitlab = Tanuki::Universe::GitlabClient.new(endpoint['options'])
          gitlab.projects.auto_paginate do |project|
            versions = {}

            git_tags = gitlab.get_git_tags(project.id)
            next if git_tags.count == 0

            git_tags.each do |tag|
              
              begin
              metadata = gitlab.get_metadata(project.id, tag.name)
              rescue Exception => e
                next if e.message == "undefined method `message' for {\"message\"=>\"404 File Not Found\"}:Hash"
              end
          
              parse_metadata(metadata)

              dependencies_hash = Hash.new { |h,k| h[k] = {} }
              if @dependencies.count == 0
                dependencies_hash["dependencies"] = {}
              end
              @dependencies.each do |k, v|
                v = '>= 0.0.0' if v.empty?
                dependencies_hash["dependencies"] = dependencies_hash["dependencies"].update({k => v})
              end
              @location_path = project.web_url + '/repository/archive.tar.gz?ref=v' + @version
              
              versions = versions.update({ @version => { "location_path" => @location_path, "location_type" => endpoint['type'] }.update(dependencies_hash)})
            end
            universe = universe.update({@cookbook_name => versions })
          end

          json_str = JSON.pretty_generate(universe)
          puts json_str
        end

        def parse_metadata(metadata)
          @dependencies = {}
          metadata.each_line do |line|
            @cookbook_name = line.gsub(/^name|'/, '').strip if line.match(/^name/)
            @version = line.gsub(/^version|'/, '').strip if line.match(/^version/)
            if line.match(/^depends/)
              depends_cookbook_name = line.split(',')[0].gsub(/^depends|'/, '').strip
              depends_version = line.split(',')[1].to_s.gsub(/'/, '').strip
              @dependencies = @dependencies.update({depends_cookbook_name => depends_version})
            end
          end
        end

      end 
    end
  end
end
