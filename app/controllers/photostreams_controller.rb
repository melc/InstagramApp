class PhotostreamsController < ApplicationController
  include PhotostreamsHelper
  require 'open-uri'
  require 'uri'
  require 'net/http'

  # def authorize
  #   @instagram_accts = InstagramAcct.all
  #   @temp_code = authorize["code"]
  #   puts @temp_code
  # end

  # def create
  #   # POST /instagram_accts
  #   # POST /instagram_accts.json
  #   @instagram_acct = InstagramAcct.new(instagram_acct_params)

  #   respond_to do |format|
  #     if @instagram_acct.save
  #       format.html { redirect_to @instagram_acct, notice: 'Instagram acct was successfully created.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: 'new' }
  #       format.json { render json: @instagram_acct.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # GET /photostreams
  # GET /photostreams.json
  def index
    @photostreams = Photostream.all
    @news_query = Photostream.pluck(:feed1)
    @photos = []
    @news = []
    @rr_profile = []
    @MAX_MEDIA = 0
    @user_name =  @photostreams[0].username;
    @user_id = @photostreams[0].user_id;
    @follow = false;

    if @photostreams.nil? 
      flash[:alert] = "Roaming Rover Error 200: Client Code Information is missing! Contact technical support."
      redirect_to root_path, flash[:alert]
    else
      @tag_count = photos_count["media_count"]

      if @tag_count > 0
        # GET photos based on tag 'dogwalk'
        first_photos_slideshow.each do |result|
          @photos << result unless result["images"]["thumbnail"]["url"].nil? 
        end
        
        for i in 1..10    # 10 pages, 20 media per page
          next_photos_slideshow.each do |result|
              @photos << result unless result["images"]["thumbnail"]["url"].nil?
          end
        end
      else
        flash[:alert] = "No photo found for this tag '" + @photostreams[0].tags1 + "'"
        redirect_to root_path, flash[:alert]
      end

      # GET roaming rover account  basic information: media, followers, and followerings
      @rr_profile << rr_profile unless rr_profile["counts"].nil?

      # GET roaming rover dog news from google newsgroup
      unless @news_query.nil? 
        rr_news.each do |result|
          @news << result unless result["title"].nil?
        end
      end

      # GET roaming rover followed by list to check if user is a follower.
      rr_follow.each do |follow|
        if follow["id"] == @user_id
          @follow = true
        end
      end

      # Update roaming rover login user's following on roaming rover
      # open_relationship_uri = "https://api.instagram.com/v1/users/" + @photostreams[0].user_id + "/relationship?access_token=" + @photostreams[0].access_token

    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photostream
      @photostream = Photostream.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def photostream_params
      params.require(:photostream).permit(:client_id, :secret_code, :access_token, :user_id, :username, :rr_user_id)
    end

    # def set_instagram_acct
    #   @instagram_acct = InstagramAcct.find(params[:id])
    # end

    # # Never trust parameters from the scary internet, only allow the white list through.
    # def instagram_acct_params
    #   params.require(:instagram_acct).permit(:access_token, :instagram_user_id, :username, :full_name, :profile_pic, :user_id)
    # end    
end
