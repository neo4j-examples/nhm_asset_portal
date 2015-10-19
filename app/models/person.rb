class Person < GraphStarter::Asset
  has_many :out, :donated_specimens, origin: :donor, model_class: :Specimen

  def self.icon_class
    'user'
  end
end
