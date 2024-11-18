class Image
  attr_accessor :link, :description
  def initialize(attributes = {})
    @link = attributes[:link]
    @description = attributes[:description]
  end

  def to_h
    {
      link: @link,
      description: @description
    }
  end
end
