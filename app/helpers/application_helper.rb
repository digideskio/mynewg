module ApplicationHelper

    def active_controller? data
        if data[:action].nil?
            "current" if params[:controller] == data[:controller]
        else
            "current" if params[:controller] == data[:controller] && params[:action] == data[:action]
        end
    end

    def create_breadcrumbs
        @breadcrumbs ||= [ { :title => 'My New Girl', :url => admin_old_root_path}]
    end

    def breadcrumb_add title, url
        create_breadcrumbs << { :title => title, :url => url }
    end

    def render_breadcrumbs
        render partial: 'admin_old/shared/breadcrumbs', locals: { breadcrumbs: create_breadcrumbs }
    end

    def table_actions object, *args
        show = args.include?('show')
        edit = args.include?('edit')
        remote_edit = args.include?('remote-edit')
        delete = args.include?('delete')
        remote_delete = args.include?('remote-delete')
        codes = args.include?('codes')
        render partial: 'admin_old/shared/table_actions', format: [:html], locals: 
        { 
            object: object, 
            show: show, 
            edit: edit, 
            del: delete, 
            remote_edit: remote_edit,
            remote_delete: remote_delete,
            codes: codes
        }
    end

    def flash_message type, text
        flash[type] ||= []
        flash[type] << text
    end   

    def render_flash
        flash_array = []
        flash.each do |type, messages|
            if messages.is_a?(String)
                flash_array << render(partial: 'admin_old/shared/flash', format: [:html], locals: { type: type, message: messages })
            else
                messages.each do |m|
                    flash_array << render(partial: 'admin_old/shared/flash', format: [:html], locals: { type: type, message: m }) unless m.blank?
                end
            end
        end
        flash_array.join('').html_safe
    end

    def package_price_type price
        return price.single? ? 'Single' : "Interval (#{price.interval})"
    end

    def javascript location, *files
        content_for(location) { javascript_include_tag(*files) }
    end

    def resource_name
        :user
    end
 
    def resource
        @resource ||= User.new
    end

    def devise_mapping
        @devise_mapping ||= Devise.mappings[:user]
    end

    def custom_errors errors
        return errors.map{|attr, msg| "Invalid #{attr.to_s.split('_').join(' ').titleize}" }.uniq
    end

    def options_from_enum_hash(hash, process = lambda { |label| label.humanize })
        hash.map do |k, v|
            label = process.call(k) if process.present?

            [label, k]
        end
    end
end
