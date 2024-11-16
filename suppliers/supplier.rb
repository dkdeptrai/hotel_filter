require 'uri'
require 'http'
require 'json'

class Supplier
  attr_accessor :hotels

  def initialize
    @hotels = []
  end

  def fetch_data
    raise NotImplementedError, "Subclasses must implement a fetch_data method"
  end

  def normalize_data(raw_data)
    raise NotImplementedError, "Subclasses must implement a normalize_data method"

  end

  def self.create_supplier(supplier_name)
    case supplier_name
    when 'acme'
      AcmeSupplier.new
    when 'patagonia'
      PatagoniaSupplier.new
    when 'paperflies'
      PaperfliesSupplier.new
    else
      raise "Unknown supplier :#{supplier_name}"
    end
  end

  protected

  def fetch_json(url)
    uri = URI(url)
    response = HTTP.get(uri)
    raise "Failed to fetch data" unless response.status.success?
    JSON.parse(response)
  end
end
