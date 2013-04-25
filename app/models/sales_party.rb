require 'savon'

class SalesParty
  extend Savon::Model
  include Pageable
  include Queryable

  @max_fetch_size = 10

  client do
    http.headers["Authorization"] = "Basic #{settings.basic_auth}"
  end
  document "#{settings.ws_host}/crmCommonSalesParties/SalesPartyService?wsdl"
  wsse_auth settings.user, settings.pwd

end