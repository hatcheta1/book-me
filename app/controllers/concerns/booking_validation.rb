module BookingValidation
  extend ActiveSupport::Concern

  def within_business_hours
    return unless business && started_at && ended_at

    day_of_week = started_at.in_time_zone(business.time_zone).strftime("%A")

    day_hours = business.business_hours.find_by(day_of_the_week: day_of_week)

    if !day_hours.closed
      opening_time = day_hours.adjusted_opening_time.strftime("%H:%M:%S")
      closing_time = day_hours.adjusted_closing_time.strftime("%H:%M:%S")

      # Validate against the business's open and close times
      if day_hours.closed || day_hours.nil?
        errors.add(:base, "The business is closed on #{day_of_week}.")
      elsif started_at.strftime("%H:%M:%S") < opening_time || ended_at.strftime("%H:%M:%S") > closing_time
        errors.add(:base, "The booking time is outside the business hours for #{day_of_week}.")
      end
    else
      errors.add(:base, "The business is closed on #{day_of_week}.")
    end
  end

  def validate_booking_time(business, client, proposed_started_at, proposed_ended_at)
    business_bookings = business.accepted_received_bookings
    client_bookings = client.sent_bookings

    bookings = business_bookings + client_bookings

    bookings.none? do |booking|
      (proposed_started_at < booking.ended_at) && (proposed_ended_at > booking.started_at)
    end
  end

  def time_slot_availability
    business = self.business
    client = self.client

    if business && started_at && ended_at
      unless validate_booking_time(business, client, started_at, ended_at)
        errors.add(:base, "The selected time slot is unavailable.")
      end
    end
  end
end
