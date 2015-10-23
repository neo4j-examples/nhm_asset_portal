class SubDepartment < GraphStarter::Asset
  property :title

  has_many :in, :specimens, origin: :sub_department

  def self.icon_class
    'building'
  end
end

