class AccountSubdomain
    def self.matches? request
        case request.subdomain
        when 'account', 'stageaccount'
            true
        else
            false
        end
    end   
end