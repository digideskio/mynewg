module UserParamable
    private

    def user_params
        params.require(:user).permit(:name, :email, :gender, :sales_code, :date_of_birth, :location,
                        :password, :password_confirmation, :phone, :line_id, :username,
                        :age, :drink, :english, :height, :kids, :smoke, :thai, :biography, :display_name, :locale, :facebook_id)
    end
end
