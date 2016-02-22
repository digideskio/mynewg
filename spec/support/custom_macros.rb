module CustomMacro
    def disable_omise
        before(:each) do
            allow_any_instance_of(User).to receive(:create_omise_customer_account).and_return(false)
        end
    end
end
