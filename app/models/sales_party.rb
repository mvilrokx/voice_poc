require 'savon'

class SalesParty
  extend Savon::Model
  include Pageable
  include Queryable

  @max_fetch_size = 10

  document "#{settings.ws_host}/crmCommonSalesParties/SalesPartyService?wsdl"
  wsse_auth settings.user, settings.pwd

end