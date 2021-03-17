class FilersController < ApplicationController
  before_action :set_filer, only: [:show, :edit, :update, :destroy]

  # GET /filers
  # GET /filers.json
  def index
    @filers = Filer.all
  end

  # GET /filers/1
  # GET /filers/1.json
  def show
  end

  # GET /filers/new
  def new
    @filer = Filer.new
  end

  # GET /filers/1/edit
  def edit
  end

  # POST /filers
  # POST /filers.json
  def create
    @filer = Filer.new(filer_params)

    respond_to do |format|
      if @filer.save
        format.html { redirect_to @filer, notice: 'Filer was successfully created.' }
        format.json { render :show, status: :created, location: @filer }
      else
        format.html { render :new }
        format.json { render json: @filer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /filers/1
  # PATCH/PUT /filers/1.json
  def update
    respond_to do |format|
      if @filer.update(filer_params)
        format.html { redirect_to @filer, notice: 'Filer was successfully updated.' }
        format.json { render :show, status: :ok, location: @filer }
      else
        format.html { render :edit }
        format.json { render json: @filer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /filers/1
  # DELETE /filers/1.json
  def destroy
    @filer.destroy
    respond_to do |format|
      format.html { redirect_to filers_url, notice: 'Filer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def parse_filers
    if params[:filename]
      filename = params[:filename]
    else
      filename = "http://s3.amazonaws.com/irs-form-990/201132069349300318_public.xml"
    end
    doc = Nokogiri::XML(URI.open(filename))

    uploaded_at = Time.now.strftime('%Y-%m-%d %H:%M:%S')

    doc.search("Filer").each do |group|
      ein_raw = group.at('EIN').to_s
      ein = ein_raw.gsub("<EIN>","").gsub("</EIN>","")

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

      if Filer.exists?(:ein => ein.to_s)
      else
        puts "start new record"
        @filer = Filer.new
        @filer.ein = ein
        @filer.name = name
        @filer.address = address
        @filer.city = city
        @filer.state = state
        @filer.zip = zip
        @filer.filename = filename
        @filer.uploaded_at = uploaded_at
        @filer.save
      end
    end
    respond_to do |format|
      format.html { redirect_to filers_url, notice: 'File was successfully parsed for Filers: ' + filename }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_filer
      @filer = Filer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def filer_params
      params.require(:filer).permit(:ein, :name, :address, :city, :state, :zip, :filename, :uploaded_at, :filename)
    end
end
