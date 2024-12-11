class BookingsController < ApplicationController
  before_action :set_booking, only: %i[ show edit update destroy accept decline ]
  before_action :normalize_business_name, only: :index_for_business
  before_action :authorize_booking,  except: [ :index_for_client, :index_for_business ]
  skip_after_action :verify_authorized, only: [:index_for_client, :index_for_business ]
  skip_after_action :verify_policy_scoped, except: [ :index_for_client, :index_for_business ]

  def index_for_business
    @business = current_user.businesses.first
    @bookings = policy_scope(@business.received_bookings) if @business
  end

  def index_for_client
    @bookings = policy_scope(current_user.sent_bookings)
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
    @services = @business.services if @business.present?
  end

  # GET /bookings/1/edit
  def edit
  end

  # POST /bookings or /bookings.json
  def create
    if current_user.businesses.exists?(id: booking_params[:business_id])
      @booking = Booking.new(booking_params)
      @booking.status = :accepted
    else
      @booking = current_user.sent_bookings.new(booking_params)
    end

    respond_to do |format|
      if @booking.save
        if current_user == @booking.business.owner
          format.html { redirect_to business_bookings_path(@booking.business.name), notice: "Booking was successfully created." }
        else
          format.html { redirect_to client_bookings_path(@booking.client.username), notice: "Booking was successfully created." }
        end
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
        if current_user == @booking.business.owner
          format.html { redirect_to business_bookings_path(@booking.business.name), notice: "Booking was successfully updated." }
        else
          format.html { redirect_to client_bookings_path(@booking.client.username), notice: "Booking was successfully updated." }
        end
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
      if current_user == @booking.business.owner
        format.html { redirect_to business_bookings_url(@booking.business.name), notice: "Booking was successfully destroyed." }
      elsif current_user == @booking.client
        format.html { redirect_to client_bookings_url(@booking.client.username), notice: "Booking was successfully destroyed." }
      end
      format.json { head :no_content }
    end
  end

  def accept
    update_booking_status(:accepted)
  end

  def decline
    update_booking_status(:declined)
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

  def authorize_booking
    authorize(@booking || Booking)
  end
  
  def update_booking_status(status)
    @booking.update!(status: status)
    redirect_to business_bookings_path(@booking.business.name), notice: "Booking #{status} successfully."
  end
end
