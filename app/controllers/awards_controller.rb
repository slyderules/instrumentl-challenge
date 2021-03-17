# require 'open-uri'
class AwardsController < ApplicationController
  before_action :set_award, only: [:show, :edit, :update, :destroy]

  # GET /awards
  # GET /awards.json
  def index
    @awards = Award.all
  end

  # GET /awards/1
  # GET /awards/1.json
  def show
  end

  # GET /awards/new
  def new
    @award = Award.new
  end

  # GET /awards/1/edit
  def edit
  end

  # POST /awards
  # POST /awards.json
  def create
    @award = Award.new(award_params)

    respond_to do |format|
      if @award.save
        format.html { redirect_to @award, notice: 'Award was successfully created.' }
        format.json { render :show, status: :created, location: @award }
      else
        format.html { render :new }
        format.json { render json: @award.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /awards/1
  # PATCH/PUT /awards/1.json
  def update
    respond_to do |format|
      if @award.update(award_params)
        format.html { redirect_to @award, notice: 'Award was successfully updated.' }
        format.json { render :show, status: :ok, location: @award }
      else
        format.html { render :edit }
        format.json { render json: @award.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /awards/1
  # DELETE /awards/1.json
  def destroy
    @award.destroy
    respond_to do |format|
      format.html { redirect_to awards_url, notice: 'Award was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def parse_awards

    currency_url = 'https://api.exchangeratesapi.io/latest?symbols=USD,GBP'
    response = HTTParty.get(currency_url)
    response.parsed_response
    puts 'response is: ' + response.to_s

    currency_factor = response["rates"]["GBP"].to_f / response["rates"]["USD"].to_f
    puts "currency_factor is: " + currency_factor.to_s

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


      if group.at('AmountOfCashGrant')
        amount_raw = group.at('AmountOfCashGrant').to_s
        amount = amount_raw.gsub("<AmountOfCashGrant>","").gsub("</AmountOfCashGrant>","")
      elsif group.at('CashGrantAmt')
        amount_raw = group.at('CashGrantAmt').to_s
        amount = amount_raw.gsub("<CashGrantAmt>","").gsub("</CashGrantAmt>","")
      end


      if group.at('PurposeOfGrant')
        purpose_raw = group.at('PurposeOfGrant').to_s
        purpose = purpose_raw.gsub("<PurposeOfGrant>","").gsub("</PurposeOfGrant>","")
      elsif group.at('PurposeOfGrantTxt')
        purpose_raw = group.at('PurposeOfGrantTxt').to_s
        purpose = purpose_raw.gsub("<PurposeOfGrantTxt>","").gsub("</PurposeOfGrantTxt>","")
      end


      if Award.exists?(:filer_ein => filer_ein.to_s, :filename => filename.to_s, :purpose => purpose.to_s, :amount => amount.to_f, :ein => ein.to_s)
      else
        puts "start new record"
        @award = Award.new
        @award.ein = ein
        @award.name = name
        @award.address = address
        @award.city = city
        @award.state = state
        @award.zip = zip
        @award.amount = amount.to_f
        @award.amount_gbp = amount.to_f * currency_factor
        @award.purpose = purpose
        @award.filename = filename
        @award.filer_ein = filer_ein
        @award.uploaded_at = uploaded_at
        @award.save
      end
    end
    respond_to do |format|
      format.html { redirect_to awards_url, notice: 'File was successfully parsed for Awards: ' + filename }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_award
      @award = Award.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def award_params
      params.require(:award).permit(:ein, :name, :address, :city, :state, :zip, :amount, :purpose, :filename)
    end
end
