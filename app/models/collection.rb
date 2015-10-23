class Collection < GraphStarter::Asset
  property :title

  has_many :in, :specimens, origin: :collection

  property :code

  def self.icon_class
    'university'
  end
end


