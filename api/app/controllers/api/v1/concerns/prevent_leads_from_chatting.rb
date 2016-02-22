module Api::V1::Concerns::PreventLeadsFromChatting
  extend ActiveSupport::Concern

  included do
    before_action :prevent_leads_from_chatting
  end

  private

  def prevent_leads_from_chatting
    raise CustomError::ChatDisabled if current_user.lead?
  end
end
