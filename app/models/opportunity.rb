require 'savon'

class Opportunity
  extend Savon::Model
  include Pageable
  include Queryable

  @max_fetch_size = 10
  @id_name = "OptyId"

  document "#{settings.ws_host}/opptyMgmtOpportunities/OpportunityService?wsdl"
  basic_auth settings.user, settings.pwd
  client.http.auth.ssl.verify_mode = :none
 	# wsse_auth settings.user, settings.pwd

end