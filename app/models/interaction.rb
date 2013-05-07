require 'savon'

class Interaction
  extend Savon::Model
  include Pageable
  include Queryable

  @max_fetch_size = 10

  document "#{settings.ws_host}/appCmmnCompInteractions/InteractionService?wsdl"
  basic_auth settings.user, settings.pwd
  client.http.auth.ssl.verify_mode = :none
 	# wsse_auth settings.user, settings.pwd

end