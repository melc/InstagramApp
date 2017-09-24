module PhotostreamsHelper

  def valid_json?(response)
    begin
      !!JSON.parse(response)
    rescue JSON::ParserError
      false
    end
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
    news_uri = "https://api.cognitive.microsoft.com/bing/v5.0/news/search?q=" + @news_query[0] + "&count=50&mkt=en-us&subscription-key=8a496e5015c84227b65c8f0522cfe9ef"

    rr_response = open(URI.escape(news_uri)).read
    puts(rr_response)
    rr_parse = JSON.parse(rr_response)

    rr_jsonResults = rr_parse["value"]            # name, url, image (.thumbnail.contentUrl), description, datePublished

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
