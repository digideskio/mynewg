class Api::ApplicationController < ActionController::Base
    include DeviseTokenAuth::Concerns::SetUserByToken
    include CustomError
    include Api::V1::Concerns::CustomControllerErrors
    
    before_action :authenticate_user!
    skip_before_filter :verify_authenticity_token
    respond_to :json


    protected

    def respond_with_interaction klass, status = nil
        interaction = klass.new(current_user: current_user, request: request, params: params)

        if status.nil?
            respond_with interaction, location: false
        else
            render json: interaction, location: false, status: status
        end
    end

    ActionController::Renderers.add :json do |json, options|
        unless json.kind_of?(String)
            json = json.as_json(options) if json.respond_to?(:as_json)
            json = JSON.pretty_generate(json, options)
        end

        if options[:callback].present?
            self.content_type ||= Mime::JS
            "#{options[:callback]}(#{json})"
        else
            self.content_type ||= Mime::JSON
            json
        end
    end
end