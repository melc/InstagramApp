module PhotostreamsHelper
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

  def news
    render :partial => "news", :layout => false
  end

  def rr_follow
 	end
end
