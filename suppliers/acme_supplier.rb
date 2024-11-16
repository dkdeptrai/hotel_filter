require_relative 'supplier'

# This supplier doesn't supply images, and country is in code form
class AcmeSupplier < Supplier
  COUNTRY_CODE = {
    'SG' => 'Singapore',
    'JP' => 'Japan'
  }.freeze

  def fetch_data
    raw_data = fetch_json("https://5f2be0b4ffc88500167b85a0.mockapi.io/suppliers/acme")

    raw_data.each do |hotel_data|
      hotel = normalize_data(hotel_data)
      @hotels << hotel
    end

    @hotels
  end

  private

  def normalize_data(hotel_data)
    hotel = {}

    hotel[:id] = hotel_data['Id']
    puts "Processing hotel id #{hotel[:id]}"
    hotel[:destination_hotel] = hotel_data['DestinationId']
    hotel[:name] = hotel_data['Name']&.strip || nil
    hotel[:description] = hotel_data['Description']&.strip || nil

    amenities = normalize_amenities(hotel_data)
    hotel[:amenities] = amenities

    location = normalize_location(hotel_data)
    hotel[:location] = location

    hotel
  end

  def normalize_amenities(hotel_data)
    {
      general: hotel_data['Facilities']&.map(&:strip) || []
    }
  end

  def normalize_location(hotel_data)
    {
      lng: hotel_data['Longitude'] || nil,
      lat: hotel_data['Latitude'] || nil,
      address: hotel_data['Address']&.strip || nil,
      country: COUNTRY_CODE[hotel_data['Country']] || nil,
      city: hotel_data['City']&.strip || nil,
    }
  end
end
