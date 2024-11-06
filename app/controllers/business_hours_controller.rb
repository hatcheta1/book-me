class BusinessHoursController < ApplicationController
  before_action :set_business_hour, only: %i[ show edit update destroy ]

  # GET /business_hours or /business_hours.json
  def index
    @business_hours = BusinessHour.all
  end

  # GET /business_hours/1 or /business_hours/1.json
  def show
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
    @business_hour = BusinessHour.new(business_hour_params)

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
        format.html { redirect_to business_hour_url(@business_hour), notice: "Business hour was successfully updated." }
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

    # Only allow a list of trusted parameters through.
    def business_hour_params
      params.require(:business_hour).permit(:business_id, :day_of_the_week, :opening_time, :closing_time, :closed)
    end
end
