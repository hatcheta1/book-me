class BookingMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.booking_mailer.booking_created.subject
  #
  def booking_created(booking)
    @booking = booking
    @user = booking.client

    mail(to: @user.email, subject: 'New Appointment Booked')
  end
end
