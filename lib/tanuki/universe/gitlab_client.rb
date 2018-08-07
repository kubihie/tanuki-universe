require 'gitlab'

module Tanuki
  module Universe
    class GitlabClient

      GITLAB_API_VERSION = 'v4'

      attr_reader :projects

      def initialize(options)
        parse_options(options)
        endpoint = "#{@opt_url}api/#{GITLAB_API_VERSION}"
        @client = Gitlab.client(endpoint: endpoint, private_token: @opt_private_token)
      end

      def parse_options(options)
        @opt_group = ENV['GITLAB_COOKBOOKS_GROUP'] || options['group']
        @opt_private_token = ENV['GITLAB_API_PRIVATE_TOKEN'] || options['private_token']
        @opt_url = ENV['GITLAB_API_ENDPOINT'] || options['url']
      end
      
      def get_groups
        @opt_groups = @client.group_search(@opt_group)
      end

      def get_projects(group_id)
         @projects = @client.group(group_id)
      end

      def get_git_tags(project_id)
        @client.tags(project_id)
      end

      def get_metadata(project_id, ref)
        @client.file_contents(project_id, 'metadata.rb', ref)
      end

    end
  end
end
