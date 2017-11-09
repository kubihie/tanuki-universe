# Tanuki::Universe

Generate universe file from private Gitlab.

Please see the following URL(https://docs.chef.io/api_chef_server.html#universe).

## Caution(2017/11/09)⚠️

Please add this to Gemfile.
```
gem 'gitlab', git: 'https://github.com/NARKOZ/gitlab.git'
```
It needs to be obtained from master branch to require fixes not included in the latest release.



## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tanuki-universe'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tanuki-universe

## Usage

Create config file. (Default is 'config.json')

```
{
  "endpoints": [
    {
      "type": "gitlab",
      "options": {
        "group": "cookbooks_group_name",
        "private_token": "ZAQWSXCDERFVBGTYHN",
        "url": "https://your_gitlab_domain/"
      }
    }
  ]
}
```

"group" can be omitted. In that case, It will search for Cookbook from all repositories.

You can also use environment variables.
- ENV['GITLAB_API_ENDPOINT']
- ENV['GITLAB_API_PRIVATETOKEN']
- ENV['GITLAB_COOKBOOKS_GROUP']

Even then you need config file below.
```
{
  "endpoints": [
    {
      "type": "gitlab",
      "options": {}
    }
  ]
}
```


```
Commands:
  tanuki-universe generate        # Generate universe file.
  tanuki-universe help [COMMAND]  # Describe available commands or one specific command
  tanuki-universe version         # Display tanuki-universe version.
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kubihie/tanuki-universe.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
