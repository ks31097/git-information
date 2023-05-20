# frozen_string_literal: true

require 'sinatra/base'
require 'sinatra/flash'
require 'sinatra/reloader'
require 'net/http'
require 'json'
require 'date'

require_relative 'helpers'

# create class SinatraApp
class GitInfo < Sinatra::Base
  configure :development do   # auto reloading website
    register Sinatra::Reloader
  end

  enable :sessions
  register Sinatra::Flash

  class GitNoMethodError < StandardError; end
  set :root, File.dirname(__FILE__)

  helpers Sinatra::GitInfo::Helpers

  disable :show_exceptions

  get '/' do
    erb :index
  end

  get '/info' do
    @github_login = params_github_login

    url = github_url(@github_login)
    @data = http_client(url)

    url = @data['repos_url']
    @data_repos = http_client(url)
    erb :info
  end

  not_found do
    erb :not_found
  end

  error ArgumentError do
    flash.now[:'error-message'] = "Account with name: \"#{@github_login}\" doesn\'t exist"
    erb :index
  end

  error NoMethodError do
    flash.now[:'error-message'] = 'The page you are looking for is missing.'
    erb :index
  end
end
