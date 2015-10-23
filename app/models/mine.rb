class Mine < GraphStarter::Asset
  property :title

  has_many :in, :specimens, origin: :mine

  def self.icon_class
    'bomb'
  end
end

