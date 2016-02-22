class Admin::EventsController < Admin::BaseController

  include DecomposeDatetime

  def view
    authorize Event
    set_events
  end

  def new
    authorize Event
    @event = Event.new
    set_packages
    new_hero_photo
  end

  def create
    authorize Event
    parse_datetime_params
    @event = Event.new(event_params)
    set_packages
    new_hero_photo
    if @event.save
      redirect_to view_admin_events_url
    else
      render :new
    end
  end

  def edit
    authorize Event
    set_event
    set_packages
  end

  def update
    authorize Event
    set_event
    set_packages
    parse_datetime_params
    if @event.update(event_params)
      redirect_to view_admin_events_url
    else
      render :edit
    end
  end

  def destroy
    authorize Event
    set_event
    @event.destroy
    flash_message :success, 'Event was successfully deleted.'
    redirect_to admin_events_url 
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def set_events
    @events ||= params[:type] == 'past' ? Event.past_events : Event.attendable
  end

  def new_hero_photo
    @event.build_hero_photo if @event.hero_photo.nil?
  end

  def set_packages
    @packages ||= Package.active
  end

  def parse_datetime_params
    update_datetime_params(params[:event][:start_date], 'event', 'start_date')
    update_datetime_params(params[:event][:end_date], 'event', 'end_date')
  end

  def event_params
    params.require(:event).permit(:name, :location, :description, :start_date, :end_date, :max_attendees,
                                  :hero_photo_attributes => [:id, :attachable_type, :attachable_id, :file],
                                  package_ids: [])
  end
end
