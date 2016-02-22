module RepresentativeCodeSerializer
  def serialize_representative_code r
    {
      uid: r.id,
      value: r.value,
      status: r.status,
      representative_id: r.representative_id,
      member_id: r.member_id,
      scratch_barcode: r.scratch_barcode
    }
  end
end
