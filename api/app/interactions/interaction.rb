class Interaction
    include CustomError
    attr_accessor :current_user, :params, :request, :errors

    def initialize args
        @current_user = args[:current_user]
        @params = args[:params]
        @request = args[:request]
        @errors = []
        init
    end

    def init

    end

    def as_json opts = {}
        raise StandardError.new 'Interaction.as_json should be overriden!'
    end
end
