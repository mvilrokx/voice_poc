require 'savon'

module Queryable
  extend Savon::Model

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    attr_accessor :max_fetch_size, :id_name

    def find_by_id(id)
      response = client.request :ns1, ("get_" + self.name.underscore).to_sym do
        soap.namespaces["xmlns:ns1"] = "#{client.wsdl.namespace}types/"
        soap.body = {"ns1:" + (id_name||(self.name + "Id")).camelize(:lower)  => id}
      end

      response.body[("get_" + self.name.underscore + "_response").to_sym][:result]
    end
    alias :get :find_by_id

    def find(p={})
      response = client.request :ns1, ("find_" + self.name.underscore).to_sym do
        soap.namespaces["xmlns:ns1"] = "#{client.wsdl.namespace}types/"
        soap.body do |xml|
          xml.ns1(:findCriteria, "xmlns:ns2" => "http://xmlns.oracle.com/adf/svc/types/") do |xml|
            xml.ns2(:fetchStart, fetch_start(p[:page], p[:page_size]||max_fetch_size))
            xml.ns2(:fetchSize, fetch_size(p[:page_size]||max_fetch_size))
            filter(p[:search], xml) # if p[:search]
            sort_order(p[:sort], xml) if p[:sort]
          end
        end
      end
      response.body[("find_" + self.name.underscore + "_response").to_sym][:result]
    end
    alias :all :find

    private
      def filter(where, xml)
        xml.ns2(:filter) do |xml|
          xml.ns2(:group) do |xml|
            add_filter(id_name||(self.name.camelize + "Id"), '%', xml, 'like') # "dummy" query criteria to avoid issue with find services that require at least 1 criteria
            where.each do |a, v|
              add_filter(a, v, xml)
            end if where
          end
        end
      end

      def add_filter(a, v, xml, o='=')
        xml.ns2(:item) do |xml|
          xml.ns2(:conjunction, "And") # Hard Coded ... for now
          xml.ns2(:upperCaseCompare, true) # Hard Coded ... for now
          xml.ns2(:attribute, a)
          xml.ns2(:operator, o) # Hard Coded ... for now
          xml.ns2(:value, v)
        end
      end

      def sort_order(sort, xml)
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

  #put instance methods here

end