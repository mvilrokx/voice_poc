require 'savon'

class Opportunity
  extend Savon::Model
  include Pageable
  include Queryable

  @max_fetch_size = 10
  @id_name = "OptyId"

  client do
    http.headers["Authorization"] = "Basic #{settings.basic_auth}"
  end
  document "#{settings.ws_host}/opptyMgmtOpportunities/OpportunityService?wsdl"
  wsse_auth settings.user, settings.pwd

end