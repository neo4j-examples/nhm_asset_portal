class AssetsController < ::GraphStarter::AssetsController
  def home
    @specimens = Specimen.all
  end
end

