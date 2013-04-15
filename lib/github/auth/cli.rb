module Github::Auth
  class CLI
    attr_reader :command, :usernames

    COMMANDS = %w(add remove)

    def initialize(argv)
      @command   = argv.shift
      @usernames = argv
    end

    def execute
      if COMMANDS.include?(command) && !usernames.empty?
        send command
      else
        print_usage
      end
    end

    private

    def add
      rescue_keys_file_errors do
        puts "Adding #{keys.count} key(s) to '#{keys_file.path}'"
        keys_file.write! keys
      end
    end

    def remove
      rescue_keys_file_errors do
        puts "Removing #{keys.count} key(s) from '#{keys_file.path}'"
        keys_file.delete! keys
      end
    end

    def rescue_keys_file_errors
      yield
    rescue KeysFile::PermissionDeniedError
      print_permission_denied
    rescue KeysFile::FileDoesNotExistError
      print_file_does_not_exist
    end

    def print_usage
      puts "usage: github-auth [#{COMMANDS.join '|'}] <username>"
    end

    def print_permission_denied
      puts 'Permission denied!'
      puts
      puts "Make sure you have write permissions for '#{keys_file.path}'"
    end

    def print_file_does_not_exist
      puts "Keys file does not exist!"
      puts
      puts "Create one now and try again:"
      puts
      puts "  $ touch #{keys_file.path}"
    end

    def print_github_user_does_not_exist(username)
      puts "Github user '#{username}' does not exist"
    end

    def print_github_unavailable
      puts "Github appears to be unavailable :("
      puts
      puts "https://status.github.com"
    end

    def keys
      @keys ||= usernames.map { |username| keys_for username }.flatten.compact
    end

    def keys_for(username)
      Github::Auth::KeysClient.new(
        hostname: github_hostname,
        username: username
      ).keys
    rescue Github::Auth::KeysClient::GithubUserDoesNotExistError
      print_github_user_does_not_exist username
    rescue Github::Auth::KeysClient::GithubUnavailableError
      print_github_unavailable
    end

    def keys_file
      Github::Auth::KeysFile.new path: keys_file_path
    end

    def keys_file_path
      Github::Auth::KeysFile::DEFAULT_PATH
    end

    def github_hostname
      Github::Auth::KeysClient::DEFAULT_HOSTNAME
    end
  end
end