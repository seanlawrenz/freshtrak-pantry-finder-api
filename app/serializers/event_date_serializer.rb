# frozen_string_literal: true

# Serializer to strip away the cruft in the event_dates table
class EventDateSerializer < ActiveModel::Serializer
  attributes :id

  attribute :event_id do
    object.event.event_id
  end

  attribute :start_time do
    start_time = object.start_time_key.to_s
    start_time = "0#{start_time}" if start_time.length == 3
    minutes = start_time.split(//).last(2).join
    if minutes == '00'
      Time.strptime(start_time, '%H%M').strftime('%l %p').lstrip
    else
      Time.strptime(start_time, '%H%M').strftime('%l:%M %p').lstrip
    end
  end

  attribute :end_time do
    end_time = object.end_time_key.to_s
    end_time = "0#{end_time}" if end_time.length == 3
    minutes = end_time.last(2)
    if minutes == '00'
      Time.strptime(end_time, '%H%M').strftime('%l %p').lstrip
    else
      Time.strptime(end_time, '%H%M').strftime('%l:%M %p').lstrip
    end
  end

  attribute :date do
    Date.parse(object.date.to_s)
  end
end
