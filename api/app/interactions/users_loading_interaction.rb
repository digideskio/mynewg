class UsersLoadingInteraction < Interaction
    include UserSerializer
    attr_reader :users, :paginated_users, :page, :limit, :gender

    def init
    end

    def as_json opts = {}
        # Backwards compatibility for the mobile apps - REMOVE AFTER APPS UPDATED IN LIVE
        if params[:page].present?
            {
                total: paginated_users.total_entries,
                per_page: limit,
                pages: paginated_users.total_pages,
                current_page: page,
                users: paginated_users.map { |u| serialize_user(u) }
            }
        else
            {
                users: filtered_users.map { |u| serialize_user(u) }
            }
        end
    end

    private

    def page
        params[:page].present? ? params[:page].to_i : 1
    end

    def limit
        params[:limit].present? ? params[:limit].to_i : 15
    end

    def gender
        params[:gender].present? ? params[:gender].downcase : nil
    end

    def users
        User.includes(:profile_photo, :cover_photo).where.not(id: current_user.id).discover_users.all
    end

    def filtered_users
        gender.present? ? (gender == 'male' ? users.male : gender == 'female' ? users.female : users) : users
    end

    def paginated_users
        filtered_users.page(page).per_page(limit).order(updated_at: :desc)
    end
end