require_relative 'supplier'

# This supplier doesn't provide longitude and latitude, but provides additional booking conditions
class PaperfliesSupplier < Supplier

  def fetch_data
    begin
      raw_data = fetch_json("https://5f2be0b4ffc88500167b85a0.mockapi.io/suppliers/paperflies")
      raw_data.each do |hotel_data|
        hotel = normalize_data(hotel_data)
        @hotels << hotel
      end
    rescue => e
      Logger.new(STDOUT).error "Error fetching data from Paperflies API: #{e.message}"
      raise
    end

    @hotels
  end

  private

  def normalize_data(hotel_data)
    hotel = {}

    hotel[:id] = hotel_data['hotel_id']
    Logger.new(STDOUT).info "Processing hotel id #{hotel[:id]}"

    hotel[:destination_id] = hotel_data['destination_id']
    hotel[:name] = hotel_data['hotel_name']&.strip
    hotel[:description] = hotel_data['details']&.strip

    amenities = normalize_amenities(hotel_data)
    hotel[:amenities] = amenities

    images = normalize_images(hotel_data)
    hotel[:images] = images

    location = normalize_location(hotel_data)
    hotel[:location] = location

    hotel[:booking_conditions] = hotel_data['booking_conditions']

    hotel
  end

  def normalize_amenities(hotel_data)
    {
      general: hotel_data.dig('amenities', 'general')&.map { |amenity| amenity.strip.downcase } || [],
      room: hotel_data.dig('amenities', 'room')&.map { |amenity| amenity.strip.downcase } || []
    }
  end

  def normalize_images(hotel_data)
    {
      rooms: (hotel_data.dig('images', 'rooms') || []).map do |image|
        {
          link: image['link']&.strip,
          description: image['caption']&.strip
        }
      end,
      site: (hotel_data.dig('images', 'site') || []).map do |image|
        {
          link: image['link']&.strip,
          description: image['caption']&.strip
        }
      end
    }
  end

  def normalize_location(hotel_data)
    {
      address: hotel_data.dig('location', 'address')&.strip,
      country: hotel_data.dig('location', 'country')&.strip,
    }
  end
end
