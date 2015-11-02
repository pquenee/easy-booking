class BookingsController < ApplicationController
  before_filter :authenticate
  before_action :set_booking, only: [:show, :edit, :update, :destroy]
  before_action :set_contacts, only: [:new, :edit]

  def new
   @booking = Booking.new
  end

  def create
   @booking = Booking.new(booking_params)

    respond_to do |format|
      if @booking.save
        format.html { redirect_to @booking, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @booking }
      else
        set_contacts
        format.html { render :new }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /bookings/1
  def show
    puts "Show calendar from this date: " + @booking.start.strftime("%d/%m/%Y")
    redirect_to '/calendar/' + @booking.start.strftime("%m%Y")
  end

  # GET /bookings/1/edit
  # fill booking form with recorded data
  def edit
  end

  # PATCH/PUT /bookings/1
  # PATCH/PUT /bookings/1.json
  def update
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to @booking, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @booking }
      else
        set_contacts
        format.html { render :edit }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookings/1
  # DELETE /bookings/1.json
  def destroy
    @booking.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_contacts
     @contacts = Contact.all
    end
    
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    end
   
    # Never trust parameters from the scary internet, only allow the white list through.
    def booking_params
      params.require(:booking).permit(:name, :phone, :start, :end, :full_price, :reduced_price)
    end
end