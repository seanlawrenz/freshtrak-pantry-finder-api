# frozen_string_literal: true

# Physical event at a location
class Event < ApplicationRecord
  alias_attribute :id, :event_id
  alias_attribute :lat, :pt_latitude
  alias_attribute :long, :pt_longitude

  belongs_to :agency, foreign_key: :loc_id, inverse_of: :events
  belongs_to :service_type, foreign_key: :service_id, inverse_of: :events
  has_one :service_category, through: :service_type
  has_many :event_zip_codes, foreign_key: :event_id, inverse_of: :event,
                             dependent: :restrict_with_exception
  has_many :event_dates, foreign_key: :event_id, inverse_of: :event,
                         dependent: :restrict_with_exception
  has_many :forms, primary_key: :form_master_num, foreign_key: :form_master_num,
                   inverse_of: :event, dependent: :restrict_with_exception

  default_scope { active.published }
  scope :active, -> { where(status_id: 1) }
  scope :published, -> { where(status_publish_event: 1) }
  scope :publishes_dates, -> { where(status_publish_event_dates: 1) }

  def exception_note(zip_code)
    # if zip_code parameter submitted use it, otherwise use event.zip
    event_zip = if zip_code
                  event_zip_codes.find_by(zip_code: zip_code)
                else
                  event_zip_codes.find_by(zip_code: zip)
                end
    return unless event_zip

    event_zip.exception_note
  end

  def agency_name
    agency.loc_name
  end
end
