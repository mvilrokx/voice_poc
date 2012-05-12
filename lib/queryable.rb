require 'savon'

module Queryable
  extend Savon::Model

  def self.included(base)
    base.extend(ClassMethods)
    puts base.class.name
  end
  
  module ClassMethods

    def find(p={}, klass=self)
      response = client.request :ns1, ("find_" + klass.name.downcase).to_sym do
        soap.namespaces["xmlns:ns1"] = "#{client.wsdl.namespace}types/"
        soap.body do |xml|
          xml.ns1(:findCriteria, "xmlns:ns2" => "http://xmlns.oracle.com/adf/svc/types/") do |xml|
            xml.ns2(:fetchStart, fetch_start(p[:page], p[:page_size]||klass.max_fetch_size))
            xml.ns2(:fetchSize, fetch_size(p[:page_size]||klass.max_fetch_size))
            filter(p[:search], xml) if p[:search]
            sort_order(p[:sort], xml) if p[:sort]
          end
        end
      end
      response.body[("find_" + klass.name.downcase + "_response").to_sym][:result]
    end
    alias :all :find

    def filter(where, xml)
      xml.ns2(:filter) do |xml|
        xml.ns2(:group) do |xml|
          where.each do |a, v|
            xml.ns2(:item) do |xml|
              add_filter(a, v, xml)
            end
          end
        end
      end
    end

    def add_filter(a, v, xml)
      xml.ns2(:conjunction, "And") # Hard Coded ... for now
      xml.ns2(:upperCaseCompare, true) # Hard Coded ... for now
      xml.ns2(:attribute, a)
      xml.ns2(:operator, "=") # Hard Coded ... for now
      xml.ns2(:value, v)
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