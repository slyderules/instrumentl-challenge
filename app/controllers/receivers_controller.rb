class ReceiversController < ApplicationController
  before_action :set_receiver, only: [:show, :edit, :update, :destroy]

  # GET /receivers
  # GET /receivers.json
  def index
    @receivers = Receiver.all
  end

  # GET /receivers/1
  # GET /receivers/1.json
  def show
  end

  # GET /receivers/new
  def new
    @receiver = Receiver.new
  end

  # GET /receivers/1/edit
  def edit
  end

  # POST /receivers
  # POST /receivers.json
  def create
    @receiver = Receiver.new(receiver_params)

    respond_to do |format|
      if @receiver.save
        format.html { redirect_to @receiver, notice: 'Receiver was successfully created.' }
        format.json { render :show, status: :created, location: @receiver }
      else
        format.html { render :new }
        format.json { render json: @receiver.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /receivers/1
  # PATCH/PUT /receivers/1.json
  def update
    respond_to do |format|
      if @receiver.update(receiver_params)
        format.html { redirect_to @receiver, notice: 'Receiver was successfully updated.' }
        format.json { render :show, status: :ok, location: @receiver }
      else
        format.html { render :edit }
        format.json { render json: @receiver.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /receivers/1
  # DELETE /receivers/1.json
  def destroy
    @receiver.destroy
    respond_to do |format|
      format.html { redirect_to receivers_url, notice: 'Receiver was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def parse_receivers
    if params[:filename]
      filename = params[:filename]
    else
      filename = "http://s3.amazonaws.com/irs-form-990/201132069349300318_public.xml"
    end

    doc = Nokogiri::XML(URI.open(filename))
    filer_ein = doc.at('EIN').text
    uploaded_at = Time.now.strftime('%Y-%m-%d %H:%M:%S')

    doc.search("RecipientTable").each do |group|

      if group.at('EINOfRecipient')
        ein_raw = group.at('EINOfRecipient').to_s
        ein = ein_raw.gsub("<EINOfRecipient>","").gsub("</EINOfRecipient>","")
      elsif group.at('RecipientEIN')
        ein_raw = group.at('RecipientEIN').to_s
        ein = ein_raw.gsub("<RecipientEIN>","").gsub("</RecipientEIN>","")
      else
        ein = "Blank"
      end


      if group.at('BusinessNameLine1')
        name_raw = group.at('BusinessNameLine1').to_s
        name = name_raw.gsub("<BusinessNameLine1>","").gsub("</BusinessNameLine1>","")
      elsif group.at('BusinessNameLine1Txt')
        name_raw = group.at('BusinessNameLine1Txt').to_s
        name = name_raw.gsub("<BusinessNameLine1Txt>","").gsub("</BusinessNameLine1Txt>","")
      end


      if group.at('AddressLine1')
        address_raw = group.at('AddressLine1').to_s
        address = address_raw.gsub("<AddressLine1>","").gsub("</AddressLine1>","")
      elsif group.at('AddressLine1Txt')
        address_raw = group.at('AddressLine1Txt').to_s
        address = address_raw.gsub("<AddressLine1Txt>","").gsub("</AddressLine1Txt>","")
      end


      if group.at('City')
        city_raw = group.at('City').to_s
        city = city_raw.gsub("<City>","").gsub("</City>","")
      elsif group.at('CityNm')
        city_raw = group.at('CityNm').to_s
        city = city_raw.gsub("<CityNm>","").gsub("</CityNm>","")
      end


      if group.at('State')
        state_raw = group.at('State').to_s
        state = state_raw.gsub("<State>","").gsub("</State>","")
      elsif group.at('StateAbbreviationCd')
        state_raw = group.at('StateAbbreviationCd').to_s
        state = state_raw.gsub("<StateAbbreviationCd>","").gsub("</StateAbbreviationCd>","")
      end


      if group.at('ZIPCode')
        zip_raw = group.at('ZIPCode').to_s
        zip = zip_raw.gsub("<ZIPCode>","").gsub("</ZIPCode>","")
      elsif group.at('ZIPCd')
        zip_raw = group.at('ZIPCd').to_s
        zip = zip_raw.gsub("<ZIPCd>","").gsub("</ZIPCd>","")
      end


      if Receiver.exists?(:ein => ein.to_s)
      else
        puts "start new record"
        @receiver = Receiver.new
        @receiver.ein = ein
        @receiver.name = name
        @receiver.address = address
        @receiver.city = city
        @receiver.state = state
        @receiver.zip = zip
        @receiver.filename = filename
        @receiver.uploaded_at = uploaded_at
        @receiver.save
      end
    end
    respond_to do |format|
      format.html { redirect_to receivers_url, notice: 'File was successfully parsed for Receivers: ' + filename }
      format.json { head :no_content }
    end
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_receiver
      @receiver = Receiver.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def receiver_params
      params.require(:receiver).permit(:ein, :name, :address, :city, :state, :zip, :filename, :uploaded_at, :filename)
    end
end
