require_relative 'location'
require_relative 'images'
require_relative 'amenities'

class Hotel
  attr_accessor :id, :destination_id, :name, :location, :images, :amenities, :booking_conditions, :description

  def initialize(attributes = {})
    @id = attributes[:id]
    @destination_id = attributes[:destination_id]
    @name = attributes[:name]
    @location = Location.new(attributes[:location])
    @images = Images.new(attributes[:images])
    @amenities = Amenities.new(attributes[:amenities])
    @booking_conditions = attributes[:booking_conditions]
    @description = attributes[:description]
  end

  def self.filter(hotels, hotel_ids: [], destination_ids: [])
    filtered_hotels = hotels

    unless hotel_ids.empty? && destination_ids.empty?
      check_all = true
      check_all = false if hotel_ids.empty? || destination_ids.empty?

      filtered_hotels = hotels.select do |hotel|
        matches_hotel_id = hotel_ids.include?(hotel.id)
        matches_destination_id = destination_ids.include?(hotel.destination_id.to_s)
        check_all ? matches_hotel_id && matches_destination_id : matches_hotel_id || matches_destination_id
      end
    end

    JSON.pretty_generate(filtered_hotels.map(&:to_h))
  end

  def to_h
    {
      id: @id,
      destination_id: @destination_id,
      name: @name,
      location: @location&.to_h,
      description: @description,
      amenities: @amenities&.to_h,
      images: @images&.to_h,
      booking_conditions: @booking_conditions
    }
  end
end
