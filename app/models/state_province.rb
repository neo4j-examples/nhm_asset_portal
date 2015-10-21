class StateProvince < GraphStarter::Asset
  has_one :out, :country, type: :IN_COUNTRY
  has_many :in, :localities, origin: :state_province
  has_many :in, :specimens, origin: :state_province

  def self.icon_class
    'flag'
  end
end

