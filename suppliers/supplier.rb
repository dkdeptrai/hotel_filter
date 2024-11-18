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

  protected

  def fetch_json(url)
    uri = URI(url)
    response = HTTP.get(uri)
    raise "Failed to fetch data" unless response.status.success?
    JSON.parse(response)
  end
end
