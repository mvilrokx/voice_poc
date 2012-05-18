require 'savon'

class Opportunity
  extend Savon::Model
  include Pageable
  include Queryable

  @max_fetch_size = 10
  @id_name = "OptyId"

  document "#{settings.ws_host}/opptyMgmtOpportunities/OpportunityService?wsdl"
  wsse_auth settings.user, settings.pwd

end