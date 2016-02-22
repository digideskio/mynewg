module Cms

    class RepCode
        attr_reader :user, :type, :gender, :count

        def initialize data
            @user               = data[:user]
            @type               = data[:type]
            @gender             = data[:gender]
            @count              = data[:count]
        end

        def multiple
            set_sequence_id
            count.times do
                create_rep_code_record(wrap_additional_data(hashids.encode(user.id, @sequence_id)))
                @sequence_id += 1
            end
        end

        def single
            set_sequence_id
            return create_rep_code_record(wrap_additional_data(hashids.encode(user.id, @sequence_id)))
        end

        def character_whitelist
            'ADEFGHJKLMNPQRTUVWXYZ23456789'
        end

        private

        def set_sequence_id
            @sequence_id = user.codes.none? ? 1 : user.codes.unscoped.order(:id).last.id.next
        end

        def hashids
            Hashids.new(Rails.application.secrets.hash_id_salt, 0, character_whitelist)
        end

        def wrap_additional_data new_code
            "#{user_initials}#{new_code}#{gender}#{type}"
        end

        def user_initials
            user.name.split.map(&:first).join.upcase
        end

        def create_rep_code_record new_code
            user.codes.create(value: new_code, gender: gender)
        end       
    end
end