class HotelDataMerger
  def self.merge(normalized_data_arrays)
    hotels_by_id = {}

    normalized_data_arrays.each do |normalized_data|
      normalized_data.each do |hotel_data|
        id = hotel_data[:id]
        if hotels_by_id[id]
          self.merge_hotel_data(hotels_by_id[id], hotel_data)
        else
          hotels_by_id[id] = hotel_data
        end
      end
    end

    hotels_by_id.values
  end

  private

  def self.merge_hotel_data(existing, new_data)
    # id and name should be the same between different suppliers so no need merging

    merge_description(existing, new_data)
    merge_images(existing, new_data)
    merge_amenities(existing, new_data)
    merge_location(existing, new_data)

    existing[:booking_conditions] = new_data[:booking_conditions] if new_data[:booking_conditions]
  end

  # Choose the longer description
  def self.merge_description(existing, new_data)
    existing[:description] ||= ''

    return if new_data[:description].nil?

    existing[:description] = new_data[:description] if existing[:description].length < new_data[:description].length
  end

  # replace if new data is available because it should be the same between different supplier
  def self.merge_location(existing, new_data)
    existing[:location][:lat] = new_data.dig(:location, :lat) if new_data.dig(:location, :lat)
    existing[:location][:lng] = new_data.dig(:location, :lng) if new_data.dig(:location, :lng)
    existing[:location][:address] = new_data.dig(:location, :address) if new_data.dig(:location, :address)
    existing[:location][:city] = new_data.dig(:location, :city) if new_data.dig(:location, :city)
    existing[:location][:country] = new_data.dig(:location, :country) if new_data.dig(:location, :country)
  end

  # add new images if not already exist a duplicate link
  def self.merge_images(existing, new_data)
    existing[:images] ||= { rooms: [], site: [], amenities: [] }

    rooms_images_links = existing.dig(:images, :rooms)&.map { |image| image[:link] } || []
    site_images_links = existing.dig(:site, :rooms)&.map { |image| image[:link] } || []
    amenities_images_links = existing.dig(:amenities, :rooms)&.map { |image| image[:link] } || []
    existing_links = Set.new(rooms_images_links + site_images_links + amenities_images_links)

    [:rooms, :site, :amenities].each do |category|
      next unless new_data.dig(:images, category)

      new_images = []

      new_data.dig(:images, category).each do |image|
        if existing_links.include?(image)
          puts "Duplicate image: #{image}"
        else
          new_images << image
          existing_links.add(image)
        end
      end
      existing[:images][category].concat(new_images) if new_images.any?
    end

    existing
  end

  # add new amenities if not already exist a duplicate amenity name
  def self.merge_amenities(existing, new_data)
    existing[:amenities] ||= { general: [], room: [] }

    general_amenities = existing.dig(:amenities, :general) || []
    room_amenities = existing.dig(:amenities, :room) || []
    existing_amenities = Set.new(general_amenities + room_amenities)

    puts existing_amenities

    [:general, :room].each do |category|
      next unless new_data.dig(:amenities, category)

      existing[:amenities][category] ||= []

      new_amenities = []

      new_data.dig(:amenities, category).each do |amenity|
        if existing_amenities.include?(amenity)
          puts "Duplicate amenity: #{amenity}"
        else
          new_amenities << amenity
          existing_amenities.add(amenity)
        end
      end

      existing[:amenities][category].concat(new_amenities) if new_amenities.any?
    end

    existing
  end

end
