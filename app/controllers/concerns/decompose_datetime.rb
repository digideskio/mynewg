module DecomposeDatetime
  extend ActiveSupport::Concern

  included do
    
    private


    def decompose_datetime(date, date_node)
      unless date.blank?
        parsed_date = Date.strptime(date, "%m/%d/%Y")
        {
          "#{date_node}(1i)" => parsed_date.year.to_s,
          "#{date_node}(2i)" => parsed_date.month.to_s,
          "#{date_node}(3i)" => parsed_date.day.to_s
        }
      else
        {
          "#{date_node}(1i)" => '',
          "#{date_node}(2i)" => '',
          "#{date_node}(3i)" => ''
        }
      end
    end

    def update_datetime_params(date, parent_node, date_node)
      params["#{parent_node}"].merge!(decompose_datetime(date, date_node))
      params["#{parent_node}"].delete("#{date_node}")
    end
  end
end
