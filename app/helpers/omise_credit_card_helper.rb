module OmiseCreditCardHelper

  def create_card user
    @card = Card.new(card_params)
    if @card.valid?
      @new_card = user.customer.cards.create(
          name: card_params[:name],
          number: card_params[:number],
          expiration_month: card_params[:expiration_month],
          expiration_year: card_params[:expiration_year],
          security_code: card_params[:security_code]
      )
    end
  end

  def delete_card(user)
    user.customer.cards.retrieve(params[:card_token]).destroy
    render json: { last: (user.customer.cards.count == 0 ? true : false) }
  end

  private

  def card_params
    params.require(:card).permit(:name, :number, :expiration_month, :expiration_year, :security_code)
  end
end