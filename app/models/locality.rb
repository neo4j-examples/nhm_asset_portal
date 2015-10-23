class Locality < GraphStarter::Asset
  property :title

  has_one :out, :state_province, type: :IN_STATE_PROVINCE
  has_many :in, :specimens, origin: :locality
end

