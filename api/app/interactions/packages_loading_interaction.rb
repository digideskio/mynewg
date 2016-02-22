class PackagesLoadingInteraction < Interaction
  include PackageSerializer
  attr_reader :packages

  def init
    @packages = Package.all
  end

  def as_json opts = {}
    {
      packages: packages.map { |p| serialize_package(p) }
    }
  end
end
