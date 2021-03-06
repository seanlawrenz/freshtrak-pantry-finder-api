# frozen_string_literal: true

module Api
  # Controller to expose Events
  class EventsController < Api::BaseController
    before_action :set_event, only: [:show]

    # GET /api/events/:id
    def show
      render json:
        ActiveModelSerializers::SerializableResource.new(@event).as_json
    end

    private

    def set_event
      @event = Event.find(params[:id])
    end
  end
end
