require 'gitlab'

module Tanuki
  module Universe
    class GitlabClient

      GITLAB_API_VERSION = 'v4'

      attr_reader :group, :private_token, :url, :projects

      def initialize(options)
        parse_options(options)
        endpoint = "#{@url}api/#{GITLAB_API_VERSION}"
        @client = Gitlab.client(endpoint: endpoint, private_token: @private_token)
        get_projects
      end

      def parse_options(options)
        @group = ENV['GITLAB_COOKBOOKS_GROUP'] || options['group']
        @private_token = ENV['GITLAB_API_PRIVATETOKEN'] || options['private_token']
        @url = ENV['GITLAB_API_ENDPOINT'] || options['url']
      end
      
      def get_projects
        @projects = @client.project_search(@group)
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
