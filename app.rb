require 'sinatra'
require 'sinatra/reloader' if development?
require 'net/http'
require 'json'
require 'date'

require_relative 'helpers'

class GitInfo < Sinatra::Base
  class GitNoMethodError < StandardError; end
  set :root, File.dirname(__FILE__)

  helpers Sinatra::GitInfo::Helpers

  disable :show_exceptions

  before do
    @title = 'Git info'
  end

  get '/' do
    erb :index
  end

  get '/info' do
    github_login = params_github_login

    url = github_url(github_login)
    @data = http_client(url)

    url = @data["repos_url"]
    @data_repos = http_client(url)

    erb :info
  end

  not_found do
    erb :not_found
  end

  error ArgumentError do
    @error = 'This account doesn\'t exist'
    erb :index
  end

  error NoMethodError do
    @error = 'The page you are looking for is missing.'
    erb :index
  end
end
