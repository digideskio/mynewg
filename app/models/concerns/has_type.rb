module HasType
    extend ActiveSupport::Concern

    included do
        def booklet?
            value.last == 'B'
        end

        def card?
            value.last == 'C'
        end

        def scratch?
            value[0,2] == 'SC'
        end
    end
end
