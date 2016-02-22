class AdminSubdomain
    def self.matches? request
        case request.subdomain
        when 'admin', 'stage'
            true
        else
            false
        end
    end   
end