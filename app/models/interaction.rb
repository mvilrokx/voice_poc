require 'savon'

class Interaction
  extend Savon::Model

  client do
    http.headers["Authorization"] = "Basic bGlzYS5qb25lczpOQnI4Nzk3OA=="
  end

  include Pageable
  include Queryable

  @max_fetch_size = 10

  document "#{settings.ws_host}/appCmmnCompInteractions/InteractionService?wsdl"
  wsse_auth settings.user, settings.pwd

end