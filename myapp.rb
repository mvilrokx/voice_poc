# myapp.rb
require 'sinatra'
require 'sinatra/respond_to'
require 'json'
require 'haml'
require 'active_support/all'

configure do
#  set :ws_host, 'http://fap0112-crm.oracleads.com'
#  set :user => 'jhenderson', :pwd => 'Welcome1' # 'BGG58595'
  set :ws_host, 'https://fap0655-crm.oracleads.com'
  set :user => 'lisa.jones', :pwd => 'NBr87978' # 'BGG58595'
  set :views, settings.root + '/app/views'
end

Sinatra::Application.register Sinatra::RespondTo

require_relative 'lib/init'
require_relative 'app/models/init'
require_relative 'app/routes/init'