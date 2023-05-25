require "open3"
require "json"
require "yaml"

require "dry/monads"

module RubocopDirector
  class RubocopStats
    include Dry::Monads[:result]

    def fetch
      File.write("./.rubocop_todo.yml", {}.to_yaml)
      stdout, stderr = Open3.capture3("bundle exec rubocop --format json")

      if stderr.length > 0
        Failure("Failed to fetch rubocop stats: #{stderr}")
      else
        Success(JSON.parse(stdout)["files"])
      end
    ensure
      Open3.capture3("git checkout ./.rubocop_todo.yml")
    end
  end
end
