class BookingsController < ApplicationController
  before_action :set_booking, only: %i[ show edit update destroy accept decline ]
  before_action :normalize_business_name, only: :index_for_business

  # GET /bookings or /bookings.json
  def index
    @bookings = Booking.all
  end

  def index_for_business
    @business = Business.find_by(owner_id: current_user.id)
    @bookings = @business.received_bookings
  end

  def index_for_client
    @client = current_user
    @bookings = @client.sent_bookings
  end

  # GET /bookings/1 or /bookings/1.json
  def show
  end

  # GET /bookings/new
  def new
    @booking = Booking.new(
      business_id: params[:business_id],
      service_id: params[:service_id]
    )

    @business = Business.find_by(id: params[:business_id])
    @service = Service.find_by(id: params[:service_id])
  end

  # GET /bookings/1/edit
  def edit
  end

  # POST /bookings or /bookings.json
  def create
    @booking = current_user.sent_bookings.new(booking_params)

    respond_to do |format|
      if @booking.save
        format.html { redirect_to bookings_path, notice: "Booking was successfully created." }
        format.json { render :show, status: :created, location: @booking }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bookings/1 or /bookings/1.json
  def update
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to booking_url(@booking), notice: "Booking was successfully updated." }
        format.json { render :show, status: :ok, location: @booking }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookings/1 or /bookings/1.json
  def destroy
    @booking.destroy!

    respond_to do |format|
      format.html { redirect_to bookings_url, notice: "Booking was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def accept
    @booking.update!(status: :accepted)
    redirect_to business_bookings_path(@booking.business.name), notice: "Booking accepted successfully."
  end

  def decline
    @booking.update!(status: :declined)
    redirect_to business_bookings_path(@booking.business.name), alert: "Booking declined."
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_booking
    @booking = Booking.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def booking_params
    params.require(:booking).permit(:client_id, :business_id, :service_id, :started_at, :ended_at, :client, :business, :service, :status)
  end

  def normalize_business_name
    if params[:business_name].include?(" ")
      redirect_to business_bookings_path(business_name: params[:business_name].tr(" ", "_")), status: :moved_permanently
    end
  end
end
