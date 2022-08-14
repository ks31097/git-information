module Sinatra
  module GitInfo
    module Helpers
      def params_github_login
        params[:github_login].split(" ").join
      end

      def github_url(github_login)
        "https://api.github.com/users/#{github_login}"
      end

      def github_avatar(id)
        "https://avatars.githubusercontent.com/u/#{id}?v=4"
      end

      def http_client(url)
        uri = URI(url)
        res = Net::HTTP.get_response(uri)
        return JSON.parse(res.body)
      end
    end
  end
end
