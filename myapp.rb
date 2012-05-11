# myapp.rb
require 'sinatra'
require 'sinatra/respond_to'
require 'json'
require 'haml'


configure do
  set :ws_host, 'http://fap0112-crm.oracleads.com'
  set :user => 'jhenderson', :pwd => 'JKH88658'
  set :views, settings.root + '/app/views'
end

Sinatra::Application.register Sinatra::RespondTo

require_relative 'lib/pageable'
require_relative 'app/models/init'
require_relative 'app/routes/init'