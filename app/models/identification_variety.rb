class IdentificationVariety < GraphStarter::Asset
  property :title

  has_many :in, :specimens, origin: :identification_variety

  def self.icon_class
    'unhide'
  end
end
