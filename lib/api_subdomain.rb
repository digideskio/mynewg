class ApiSubdomain
    def self.matches? request
        case request.subdomain
        when 'api', 'stageapi'
            true
        else
            false
        end
    end   
end