module SaleTransactionCommissionsHelper

    def status_label record
        class_name = record.pending? ? 'orange' : record.completed? ? 'green' : 'red'
        "<span class='label label-#{class_name} label-small'>#{record.status.capitalize}</span>".html_safe
    end
end
