module PhotostreamsHelper
  def authorize
    auth_uri = 'https://instagram.com/oauth/authorize/?client_id='+@photostreams[0].client_id+'&redirect_uri=http://petskids.com:3000&response_type=code';
    response = open(auth_uri).read


    puts "----------------------------------------"
    puts response
    puts "=========================================="

    # if parse["error"] == "access_denied"
    #   raise parse[error_description]
    # elsif parse["code"] == 400
    #   raise parse[error_message]
    # else
    #   return response.code unless response.code.nil?  
    # end 
  end

  def photos_count
    tag_count_uri = "https://api.instagram.com/v1/tags/" + @photostreams[0].tag1 + "?access_token=" + @photostreams[0].access_token
    response = open(tag_count_uri).read
    parse = JSON.parse(response)
    jsonTagCount = parse["data"]

    return jsonTagCount
  end

	def photos_slideshow(uri)
    response = open(uri).read
    parse = JSON.parse(response)
    jsonNextResults = parse["pagination"]
    @next_url = jsonNextResults["next_url"] unless jsonNextResults.nil?
    jsonResults = parse["data"]

    return jsonResults
  end

  def first_photos_slideshow
  	uri = "https://api.instagram.com/v1/tags/" + @photostreams[0].tag1 + "/media/recent?access_token=" + @photostreams[0].access_token
    photos_slideshow(uri)
 	end

  def next_photos_slideshow
    unless @next_url.nil?
      uri = @next_url
      photos_slideshow(uri)
    end
  end

	def rr_profile
		open_rr_uri = "https://api.instagram.com/v1/users/" + 
                  @photostreams[0].user_id + "/?access_token=" + 
                  @photostreams[0].access_token
  	rr_response = open(open_rr_uri).read
  	rr_parse = JSON.parse(rr_response)
  	rr_jsonResults = rr_parse["data"]
  	
    return rr_jsonResults
  end

  def rr_news
    news_uri = "https://ajax.googleapis.com/ajax/services/search/news?v=1.0&rsz=8&q=" + @news_query[0]

    rr_response = open(URI.escape(news_uri)).read
    rr_parse = JSON.parse(rr_response)
    rr_jsonResults = rr_parse["responseData"]["results"]

    return rr_jsonResults
  end

  def rr_follow
    follows_uri = "https://api.instagram.com/v1/users/" + @photostreams[0].user_id + 
                    "/followed-by?access_token=" + @photostreams[0].access_token  
    rr_response = open(follows_uri).read
    rr_parse = JSON.parse(rr_response)
    rr_jsonResults = rr_parse["data"]

    return rr_jsonResults                
 	end
end
