module Api::V1::Concerns::CustomControllerErrors
    extend ActiveSupport::Concern

    included do
        rescue_from ActionController::ParameterMissing, with: :parameter_missing
        rescue_from ActiveRecord::RecordInvalid, with: :invalid_record
        rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
        rescue_from CustomError::AlreadyAttending, with: :already_attending
        rescue_from CustomError::ChatDisabled, with: :chat_disabled
        rescue_from CustomError::PackageAccess, with: :package_access
        rescue_from CustomError::MaxAttendee, with: :max_attendee
        rescue_from CustomError::PackagePurchase, with: :package_purchase
        rescue_from CustomError::InvalidCard, with: :invalid_card
        rescue_from CustomError::InvalidOmisePrice, with: :invalid_omise_price
        rescue_from CustomError::InvalidLocalisation, with: :invalid_localisation
        rescue_from CustomError::InvalidRepCode, with: :invalid_rep_code
        rescue_from CustomError::CurrentUserRepCodePresent, with: :current_user_rep_code_present
    end

    protected

    def record_not_found error
        render json: { errors: error.message }, status: 404
    end

    def invalid_record error
        Rollbar.log('debug', "Invalid record. Record: #{error.record.inspect}. Errors: #{error.record.errors.map{|attr, msg| attr.to_s msg }.join(', ')}")
        render json: { errors: "Invalid #{error.record.errors.map{|attr, msg| attr.to_s == 'uid' ? next : attr.to_s.split('_').join(' ').titleize }.uniq.compact.join(', ')}" }, status: 422
    end

    def parameter_missing error
        render json: { errors: error.message }, status: 400
    end

    def chat_disabled
        render json: { errors: 'You do not have permission to chat with this user.' }, status: 422
    end

    def already_attending
        render json: { errors: 'This user is already attending the event.' }, status: 422
    end

    def package_access
        render json: { errors: 'Your package does not allow you to perform this action.' }, status: 422
    end

    def max_attendee
        render json: { errors: 'You can\'t join this event. This event has reached the maximum allowed attendees.' }, status: 422
    end

    def package_purchase
        render json: { errors: 'You do not have permission to purchase this package.' }, status: 422
    end

    def invalid_card
        render json: { errors: 'Invalid card.' }, status: 422
    end

    def invalid_omise_price
        render json: { errors: 'Invalid price for Omise.' }, status: 422
    end

    def invalid_localisation
        render json: { errors: 'Invalid language for localisation' }, status: 422
    end

    def invalid_rep_code
        render json: { errors: 'Invalid sales code. Please contact support.' }, status: 422
    end

    def current_user_rep_code_present
        render json: { errors: 'You already have a sales code associated with your account.' }, status: 422
    end
end