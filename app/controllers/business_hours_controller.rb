class BusinessHoursController < ApplicationController
  before_action :set_business_hour, only: %i[ show edit update destroy ]
  before_action :authorize_business_hour
  skip_after_action :verify_authorized, only: :index
  skip_after_action :verify_policy_scoped, except: :index

  # GET /business_hours or /business_hours.json
  def index
    @business_hours = policy_scope(current_user.business_hours).sort_by do |day_hours|
      BusinessHour::DAYS_OF_THE_WEEK.index(day_hours.day_of_the_week)
    end
  end

  # GET /business_hours/new
  def new
    @business_hour = BusinessHour.new
  end

  # GET /business_hours/1/edit
  def edit
  end

  # POST /business_hours or /business_hours.json
  def create
    @business_hour = current_user.business_hours.new(business_hour_params)

    respond_to do |format|
      if @business_hour.save
        format.html { redirect_to business_hour_url(@business_hour), notice: "Business hour was successfully created." }
        format.json { render :show, status: :created, location: @business_hour }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @business_hour.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /business_hours/1 or /business_hours/1.json
  def update
    respond_to do |format|
      if @business_hour.update(business_hour_params)
        format.html { redirect_to business_hours_url, notice: "Business hour was successfully updated." }
        format.json { render :show, status: :ok, location: @business_hour }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @business_hour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /business_hours/1 or /business_hours/1.json
  def destroy
    @business_hour.destroy!

    respond_to do |format|
      format.html { redirect_to business_hours_url, notice: "Business hour was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_business_hour
      @business_hour = BusinessHour.find(params[:id])
    end

    # Only allow a list of trusted parameters through
    def business_hour_params
      params.require(:business_hour).permit(:business_id, :day_of_the_week, :closed).tap do |whitelisted|
        whitelisted[:opening_time] = to_24_hour_time(params[:opening_time], params[:opening_time_period]) if time_present?(:opening_time)
        whitelisted[:closing_time] = to_24_hour_time(params[:closing_time], params[:closing_time_period]) if time_present?(:closing_time)
      end
    end

    def to_24_hour_time(time, period)
      hour, minute = time.split(":").map(&:to_i)
      hour += 12 if period == "PM" && hour != 12
      hour = 0 if period == "AM" && hour == 12
      format("%02d:%02d", hour, minute)
    end

    def time_present?(time_key)
      params["#{time_key}"].present? && params["#{time_key}_period"].present?
    end

    def authorize_business_hour
      authorize(@business_hour || BusinessHour)
    end
end
