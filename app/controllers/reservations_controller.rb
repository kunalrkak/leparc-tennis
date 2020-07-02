class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation_public, only: [:show]
  before_action :set_reservation, only: [:destroy]
  before_action :validate_params, only: [:create]
  before_action :validate_user_has_no_reservation_today, only: [:create]
  before_action :set_info, only: [:index]
  before_action :validate_reservation_can_be_cancelled, only: [:destroy]
  before_action :validate_reservation_is_not_old, only: [:create]

  # GET /reservations
  # GET /reservations.json
  def index
  end

  # GET /reservations/1
  # GET /reservations/1.json
  def show
  end

  # GET /reservations/new
  # def new
  #   @reservation = Reservation.new
  # end

  # GET /reservations/1/edit
  # def edit
  # end

  # POST /reservations
  # POST /reservations.json
  def create
    @reservation = Reservation.new(reservation_params)
    @reservation.user_id = current_user.id
    @reservation.date = Date.current
    @reservation.duration = 60
    @reservation.end = get_end(params)

    respond_to do |format|
      if @reservation.save
        format.html { redirect_to @reservation, notice: 'Reservation was successfully created.' }
        format.json { render :show, status: :created, location: @reservation }
      else
        format.html { render :new }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reservations/1
  # PATCH/PUT /reservations/1.json
  # def update
  #   @reservation.end = get_end(params)
  #   respond_to do |format|
  #     if @reservation.update(reservation_params)
  #       format.html { redirect_to @reservation, notice: 'Reservation was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @reservation }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @reservation.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /reservations/1
  # DELETE /reservations/1.json
  def destroy
    @reservation.destroy
    respond_to do |format|
      format.html { redirect_to reservations_url, notice: 'Reservation was successfully cancelled.' }
      format.json { head :no_content }
    end
  end

  def me 
    @reservation = Reservation.where("date = ?", Date.current).where('user_id = ?', current_user.id).first
    if @reservation == nil
      redirect_to reservations_url, alert: 'Uh-oh, looks like you haven\'t made a reservation yet today!', status: 301, 'data-turbolinks': false
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation_public
      @reservation = Reservation.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to reservations_url
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = current_user.reservations.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to reservations_url
    end

    def set_info
      @info = getAvailableTimes
    end

    # Only allow a list of trusted parameters through.
    def reservation_params
      params.permit(:start)
    end

    def validate_params
      start = Time.parse(params[:start])
      hour = start.hour
      minute = start.min
      second = start.sec
      existing_res = Reservation.where("date = ?", Date.current).where("start = ?", start).first
      if hour < 8 || hour > 20 || minute != 0 || second != 0 || existing_res
        redirect_to reservations_url, alert: "Invalid request."
      end
    end

    def validate_user_has_no_reservation_today
      reservation = Reservation.where("date = ?", Date.current).where('user_id = ?', current_user.id).first
      if reservation != nil
        redirect_to reservations_url, alert: "Sorry, you can only make one reservation per day."
      end
    end

    def validate_reservation_can_be_cancelled
      if isPastNow(@reservation.start, 30)
        redirect_to reservations_url, alert: "Sorry, you can't cancel an old reservation."
      end
    end

    def validate_reservation_is_not_old
      if isPastNow(Time.parse(params[:start]), 10)
        redirect_to reservations_url, alert: "Sorry, you can't reserve an old timeslot."
      end
    end

    def get_end(params)
      start = Time.parse(params[:start])
      (start + 59.minutes).end_of_minute
    end

    def getReservationsToday
      Reservation.where("date = ?", Date.current).all
    end

    def getAllTimes
      start = Time.at(946731600) # 8am epoch timestamp
      finish = Time.at(946778400) # 9pm epoch timestamp

      arr = []
      while start < finish do
        arr << start
        start = start + 1.hour
      end

      return arr
    end

    def getAvailableTimes
      reservations = getReservationsToday
      times = getAllTimes
      num_slots = times.length

      available = [true] * num_slots
      res_zip = [nil] * num_slots
      
      reservations.each do |reservation|
        i = times.find_index(reservation.start)
        if i != nil
          available[i] = false
          res_zip[i] = reservation
        end
      end

      return times.zip(available, res_zip)
    end

    def isPastNow(time, m)
      Time.zone.now.change(:month => 1, :day => 1, :year => 2000) > (time + m.minutes)
    end
end
