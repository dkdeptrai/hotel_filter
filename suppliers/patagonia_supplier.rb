require_relative 'supplier'

# This supplier doesn't provide country, city, and postal code
class PatagoniaSupplier < Supplier
  def fetch_data
    raw_data = fetch_json("https://5f2be0b4ffc88500167b85a0.mockapi.io/suppliers/patagonia")

    raw_data.each do |hotel_data|
      hotel = normalize_data(hotel_data)
      @hotels << hotel
    end

    @hotels
  end

  private

  def normalize_data(hotel_data)
    hotel = {}

    hotel[:id] = hotel_data['id']
    puts "Processing hotel id: #{hotel[:id]}"

    hotel[:destination_id] = hotel_data['destination']
    hotel[:name] = hotel_data['name']&.strip || nil
    hotel[:description] = hotel_data['info']&.strip || nil

    amenities = normalize_amenities(hotel_data)

    hotel[:amenities] = amenities

    location = normalize_location(hotel_data)
    hotel[:location] = location

    images = normalize_images(hotel_data)
    hotel[:images] = images

    hotel
  end

  def normalize_amenities(hotel_data)
    {
      room: hotel_data['amenities']&.map { |amenity| amenity.strip.downcase } || []
    }
  end

  def normalize_location(hotel_data)
    {
      lng: hotel_data['lng'] || nil,
      lat: hotel_data['lat'] || nil,
      address: hotel_data['address']&.strip || nil
    }
  end

  def normalize_images(hotel_data)
    {
      rooms: (hotel_data.dig('images', 'rooms') || []).map do |image|
        {
          link: image['url']&.strip || nil,
          description: image['description']&.strip || nil
        }
      end,
      amenities: (hotel_data.dig('images', 'amenities') || []).map do |image|
        {
          link: image['url']&.strip || nil,
          description: image['description']&.strip || nil
        }
      end
    }
  end
end
