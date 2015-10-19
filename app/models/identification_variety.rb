class IdentificationVariety < GraphStarter::Asset
  has_many :in, :specimens, origin: :identification_variety
end
