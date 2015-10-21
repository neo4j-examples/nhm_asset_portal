class IdentificationVariety < GraphStarter::Asset
  has_many :in, :specimens, origin: :identification_variety

  def self.icon_class
    'unhide'
  end
end
