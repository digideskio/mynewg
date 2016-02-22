require 'cms/price'
require 'cms/pay_provider'
require 'cms/discounter'
require 'cms/rep_code'
require 'cms/scratch_code'


module Cms

    class << self

        def class_name object
            return object.class.to_s.split(/(?=[A-Z])/).join(' ')
        end

        def class_name_id object
            return object.class.to_s.split(/(?=[A-Z])/).join('-').downcase
        end

        def set_role_id role
            PackagePriceCommission.roles[role]
        end

        def archive_notifications
            Notification.active.archivable.map{|n| n.archived! }
        end

        def reset_counter_caches array, relation
            array.each do |r|
                r.class.reset_counters(r.id, relation)
            end
        end
    end
end