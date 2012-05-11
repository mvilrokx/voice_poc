require 'savon'

class Interaction
  extend Savon::Model
  extend Pageable

  @@MAX_FETCH_SIZE = 2

  document "#{settings.ws_host}/appCmmnCompInteractions/InteractionService?wsdl"
  wsse_auth settings.user, settings.pwd

  def self.find_by_id(id)
    response = client.request :ns1, :get_interaction do
      soap.namespaces["xmlns:ns1"] = "#{client.wsdl.namespace}types/"
      soap.body = {"ns1:interactionId" => id}
    end

    response.body[:get_interaction_response][:result]
  end

  def self.all(p={})
    response = client.request :ns1, :find_interaction do
      soap.namespaces["xmlns:ns1"] = "#{client.wsdl.namespace}types/"
      soap.body do |xml|
        xml.ns1(:findCriteria, "xmlns:ns2" => "http://xmlns.oracle.com/adf/svc/types/") do |xml|
          xml.ns2(:fetchStart, fetch_start(p[:page], p[:page_size]||@@MAX_FETCH_SIZE))
          xml.ns2(:fetchSize, fetch_size(p[:page_size]||@@MAX_FETCH_SIZE))
        end
      end
    end

    response.body[:find_interaction_response][:result]
  end

  def self.search(p={})
    response = client.request :ns1, :find_interaction do
      soap.namespaces["xmlns:ns1"] = "#{client.wsdl.namespace}types/"
      soap.body do |xml|
        xml.ns1(:findCriteria, "xmlns:ns2" => "http://xmlns.oracle.com/adf/svc/types/") do |xml|
          xml.ns2(:fetchStart, fetch_start(p[:page], p[:page_size]||@@MAX_FETCH_SIZE))
          xml.ns2(:fetchSize, fetch_size(p[:page_size]||@@MAX_FETCH_SIZE))
          filter(p[:search], xml)
          sort_order(p[:sort], xml)
        end
      end
    end
    response.body[:find_interaction_response][:result]
  end

  def self.filter(where, xml)
    xml.ns2(:filter) do |xml|
      xml.ns2(:group) do |xml|
        where.each do |a, v|
          xml.ns2(:item) do |xml|
            xml.ns2(:conjunction, "And") # Hard Coded ... for now
            xml.ns2(:upperCaseCompare, true) # Hard Coded ... for now
            xml.ns2(:attribute, a)
            xml.ns2(:operator, "=") # Hard Coded ... for now
            xml.ns2(:value, v)
          end
        end
      end
    end
  end

  def self.sort_order(sort, xml)
    if sort
      xml.ns2(:sortOrder) do |xml|
        sort.each do |a, v|
          xml.ns2(:sortAttribute) do |xml|
            xml.ns2(:name, a)
            xml.ns2(:descending, v=="asc" ? false : true)
          end
        end
      end
    end
  end

end