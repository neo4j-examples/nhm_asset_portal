class Person < GraphStarter::Asset
  property :title

  has_many :out, :donated_specimens, origin: :donor, model_class: :Specimen

  def self.icon_class
    'user'
  end
end
