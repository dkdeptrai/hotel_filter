class Amenities
  attr_accessor :general, :room

  def initialize(attributes = {})
    @general = attributes[:general] || []
    @room = attributes[:room] || []
  end

  def to_h
    {
      general: @general,
      room: @room
    }
  end
end
