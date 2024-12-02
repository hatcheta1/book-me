class BusinessesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[ index show ]
  before_action :set_business, only: %i[ show edit update destroy ]
  before_action :normalize_business_name, only: :calendar

  # GET /businesses or /businesses.json
  def index
    @businesses = Business.all
  end

  # GET /businesses/1 or /businesses/1.json
  def show
    @business_hours = @business.business_hours.sort_by do |hour|
      BusinessHour::DAYS_OF_THE_WEEK.index(hour.day_of_the_week)
    end
  end

  # GET /businesses/new
  def new
    @business = Business.new
  end

  # GET /businesses/1/edit
  def edit
  end

  # POST /businesses or /businesses.json
  def create
    @business = Business.new(business_params)
    @business.owner = current_user

    respond_to do |format|
      if @business.save
        format.html { redirect_to business_url(@business), notice: "Business was successfully created." }
        format.json { render :show, status: :created, location: @business }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @business.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /businesses/1 or /businesses/1.json
  def update
    respond_to do |format|
      if @business.update(business_params)
        format.html { redirect_to business_url(@business), notice: "Business was successfully updated." }
        format.json { render :show, status: :ok, location: @business }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @business.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /businesses/1 or /businesses/1.json
  def destroy
    @business.destroy!

    respond_to do |format|
      format.html { redirect_to businesses_url, notice: "Business was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def calendar
    @business = Business.find_by(name: params[:business_name].tr("_", " "))
    if @business.nil?
      redirect_to root_path, alert: "Business not found."
      return
    end
    @bookings = @business.accepted_received_bookings.where(
      "started_at >= ? AND started_at <= ?", Date.today.beginning_of_week, Date.today.end_of_week
  )
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_business
      @business = Business.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def business_params
      params.require(:business).permit(:owner_id, :name, :address, :about, :logo)
    end

    def normalize_business_name
      if params[:business_name].include?(" ")
        redirect_to business_calendar_path(business_name: params[:business_name].tr(" ", "_")), status: :moved_permanently
      end
    end
end
