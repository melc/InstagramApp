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

  before_filter :authenticate_user!
  # GET /photostreams
  # GET /photostreams.json
  def index
    # if a login user, display photostream; otherwise, popup sign up/sign in page
    if user_signed_in?

      if (Photostream.find_by user_id: current_user.id).nil?
        @photostream = Photostream.new
        @photostream.access_token = ENV["INSTAGRAM_ACCESS_TOKEN"]
        @photostream.uid = ENV["INSTAGRAM_UID"]
        @photostream.username = current_user.username
        @photostream.tag1 = ENV["INSTAGRAM_TAG"]
        @photostream.feed1 = ENV["INSTAGRAM_FEED"]
        @photostream.media = 0
        @photostream.follows = 0
        @photostream.followed_by = 0
      else
        @photostream = Photostream.find_by user_id: current_user.id
        @photostream.tag1 = ENV["INSTAGRAM_TAG"]
        @photostream.feed1 = ENV["INSTAGRAM_FEED"]
        @photostream.media = counts["media"]
        @photostream.follows = counts["follows"]
        @photostream.followed_by = counts["followed_by"]
        @photostream.save

      end

      @photos = []
      @next_url = []
      @news = []
      @follow = false

=begin
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
=end
      @auth_uri = 'https://instagram.com/oauth/authorize/?client_id=' + ENV["INSTAGRAM_CLIENT_ID"] +
            '&redirect_uri=https://clappaws.org/users/auth/instagram/callback&response_type=code&scope=public_content+follower_list+comments'
      response = open(@auth_uri).read

      @user_id = current_user.id
      @tag_count = photos_count["media_count"]

      if @tag_count > 0
          first_photos_slideshow.each do |result|
            @photos << result unless result["images"]["thumbnail"]["url"].nil?
          end

          for i in 1..10    # 10 pages, 20 media per page
            unless @next_url.blank?
              next_photos_slideshow.each do |result|
                @photos << result unless result["images"]["thumbnail"]["url"].nil?
              end
            end
          end
      else
          flash[:alert] = "No photo found for this tag '" + @photostream.tag1 + "'"
          redirect_to root_path
      end

      # GET ClapPaws dog news from google newsgroup
      unless @photostream.feed1.nil?
        news_bar.each do |result|
          @news << result unless result["name"].nil?
        end
      end

      # check if current user is a follower of ClapPaws
      if !@photostream.follows.blank?
        follow.each do |follow|
          if follow["id"] == @photostream.uid && !(@photostream.uid == ENV["INSTAGRAM_UID"])
            @follow = true
          end
        end
      end
    end
  end

  private
      # Use callbacks to share common setup or constraints between actions.
      def set_photostream
        @photostream = Photostream.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def photostream_params
        params.require(:photostream).permit(:provider, :access_token, :uid, :username, :user_id)
      end
  end
