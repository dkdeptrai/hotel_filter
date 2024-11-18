class Location
  attr_accessor :name, :address, :lat, :lng, :city, :country

  def initialize(attributes = {})
    @lat = attributes[:lat]
    @lng = attributes[:lng]
    @address = attributes[:address]
    @city = attributes[:city]
    @country = attributes[:country]
  end

  def to_h
    {
      lat: @lat,
      lng: @lng,
      address: @address,
      city: @city,
      country: @country
    }
  end
end
