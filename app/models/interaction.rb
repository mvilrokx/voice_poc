require 'savon'

class Interaction
  extend Savon::Model
  include Pageable
  include Queryable

  @max_fetch_size = 10

  document "#{settings.ws_host}/appCmmnCompInteractions/InteractionService?wsdl"
  wsse_auth settings.user, settings.pwd

  def self.find_by_id(id)
    response = client.request :ns1, :get_interaction do
      soap.namespaces["xmlns:ns1"] = "#{client.wsdl.namespace}types/"
      soap.body = {"ns1:interactionId" => id}
    end

    response.body[:get_interaction_response][:result]
  end

  class << self
    attr_accessor :max_fetch_size 
  end

end