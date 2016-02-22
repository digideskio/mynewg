class OmiseController < ApplicationController
    include SetUser
    skip_before_action :user_frozen!
    before_action :authenticate_user!

    def create_card
        set_user
        @card = Card.new(card_params)
        if @card.valid?
            @new_card = @user.customer.cards.create(
                name: card_params[:name],
                number: card_params[:number],
                expiration_month: card_params[:expiration_month],
                expiration_year: card_params[:expiration_year],
                security_code: card_params[:security_code]
            )
            render json: { card: render_to_string(partial: 'users/billing/card', format: [:html], object: @new_card ), first: (@user.customer.cards.count == 1 ? true : false) }, status: 200
        else
            render json: { errors: @card.errors.full_messages }, status: 422
        end
    end

    def delete_card
        set_user
        @user.customer.cards.retrieve(params[:card_token]).destroy
        render json: { last: (@user.customer.cards.count == 0 ? true : false) }
    end

    private

    def card_params
        params.require(:card).permit(:name, :number, :expiration_month, :expiration_year, :security_code)
    end
end