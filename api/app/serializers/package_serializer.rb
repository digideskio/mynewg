module PackageSerializer
  def serialize_package p
    {
      name: p.name
    }
  end
end
