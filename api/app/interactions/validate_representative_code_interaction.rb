class ValidateRepresentativeCodeInteraction < Interaction


    def as_json opts = {}
        {
            code_available: code_valid?,
            gender: gender
        }
    end

    private

    def code_valid?
        RepresentativeCode.valid_code?(params[:code])
    end

    def gender
        g          = { 'M'.freeze => :male, 'F'.freeze => :female }
        g.default  = :unknown

        code_valid? ? g[params[:code][-2]] : g.default
    end
end
