module Cms

    class ScratchCode
        attr_reader :count

        def initialize data
            @count               = data[:count] 
        end

        def multiple
            set_sequence_id
            count.times do
                create_scratch_code_record(wrap_additional_data(hashids.encode(@sequence_id)))
                @sequence_id += 1
            end
        end

        def character_whitelist
            'ADEFGHJKLMNPQRTUVWXYZ23456789'
        end

        private

        def set_sequence_id
            @sequence_id = RepresentativeCode.scratch.empty? ? 1 : RepresentativeCode.unscoped.scratch.order(:id).last.id.next
        end

        def set_scratch_barcode
            return RepresentativeCode.scratch.empty? ? 323000 : RepresentativeCode.unscoped.scratch.order(:id).last.scratch_barcode.next
        end

        def hashids
            Hashids.new(Rails.application.secrets.hash_id_salt, 0, character_whitelist)
        end

        def wrap_additional_data new_code
            "SC#{new_code}"
        end

        def create_scratch_code_record new_code
            RepresentativeCode.create(value: new_code, scratch_barcode: set_scratch_barcode)
        end        
    end
end