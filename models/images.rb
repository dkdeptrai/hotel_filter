require_relative 'image'

# Images group by type
class Images
  attr_accessor :rooms, :site, :amenities
  def initialize(attributes = {})
    @rooms = attributes[:rooms].map { |img| Image.new(img) }
    @site = attributes[:site].map { |img| Image.new(img) }
    @amenities = attributes[:amenities].map { |img| Image.new(img) }
  end

  def to_h
    {
      rooms: @rooms.map(&:to_h),
      site: @site.map(&:to_h),
      amenities: @amenities.map(&:to_h)
    }
  end
end
