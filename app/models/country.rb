class Country < GraphStarter::Asset
  property :title

  has_many :in, :specimens, origin: :country
  has_many :in, :state_provinces, origin: :country

  def self.icon_class
    'flag'
  end
end

