#  Create Instagram account to get client_id and client_secret
#  Generate Access Token to execute the following code
#  https://api.instagram.com/oauth/authorize/?client_id=<CLIENT-ID>&redirect_uri=<domain>&response_type=code
#  http://<domain>?code=<CODE>
#    curl -F 'client_id=<CLIENT_ID>' \
#    -F 'client_secret=<CLIENT_SECRET>' \
#    -F 'grant_type=authorization_code' \
#    -F 'redirect_uri=<domain>' \
#    -F 'code=<CODE>' \
#  https://api.instagram.com/oauth/access_token

class PhotostreamsController < ApplicationController
  include PhotostreamsHelper
  require 'open-uri'
  require 'uri'
  require 'net/http'

  # GET /photostreams
  # GET /photostreams.json
  def index
    #@photostreams = Photostream.find(params[:id]);
    @photostreams = Photostream.all
    @news_query = Photostream.pluck(:feed1)
    @photos = []
    @news = []
    @rr_profile = []
    @MAX_MEDIA = 0
    @follow = false

    if @photostreams.blank?
      @auth_uri = 'https://instagram.com/oauth/authorize/?client_id=' + @photostreams[0].client_id +
          '&redirect_uri=https://clappaws.org&response_type=code&scope=basic+public_content+likes+relationships+follower_list+comments'
      response = open(@auth_uri).read

      if valid_json?(response)

        if JSON.parse(response)["error"] == "access_denied"
          raise JSON.parse(response)[error_description]
        elsif JSON.parse(response)["code"] == 400
          raise JSON.parse(response)[error_message]
        else
          return response.code unless response.code.blank?
        end
      end

      flash[:alert] = "ClapPaws needs to access your instagram account"
      redirect_to @auth_uri
    else
      @user_name =  @photostreams[0].username
      @user_id = @photostreams[0].user_id
      @tag_count = photos_count["media_count"]
      if @tag_count > 0
        # GET photos based on tag 'dogwalk'
        first_photos_slideshow.each do |result|
            @photos << result unless result["images"]["thumbnail"]["url"].nil?
        end
        
        for i in 1..10    # 10 pages, 20 media per page
          unless next_photos_slideshow.blank?
            next_photos_slideshow.each do |result|
              @photos << result unless result["images"]["thumbnail"]["url"].nil?
            end
          end
        end
      else
        flash[:alert] = "No photo found for this tag '" + @photostreams[0].tags1 + "'"
        redirect_to root_path
      end

      # GET ClapPaws account  basic information: media, followers, and followerings
      @rr_profile << rr_profile unless rr_profile["counts"].nil?

      # GET ClapPaws dog news from google newsgroup
      unless @news_query.nil? 
        rr_news.each do |result|
          @news << result unless result["name"].nil?
        end
      end

      # GET ClapPaws followed by list to check if user is a follower.
      rr_follow.each do |follow|
        if follow["id"] == @user_id
          @follow = true
        end
      end

      # Update ClapPaws login user's following on ClapPaws
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

end
