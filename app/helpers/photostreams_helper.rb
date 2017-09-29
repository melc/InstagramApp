module PhotostreamsHelper

  def valid_json?(response)
    begin
      !!JSON.parse(response)
    rescue JSON::ParserError
      false
    end
  end

  def photos_count
    tag_count_uri = "https://api.instagram.com/v1/tags/" + @photostream.tag1 +
        "?access_token=" + ENV["INSTAGRAM_ACCESS_TOKEN"] + "&scope=public_content"
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
  	uri = "https://api.instagram.com/v1/tags/" + @photostream.tag1 + "/media/recent?access_token=" + ENV["INSTAGRAM_ACCESS_TOKEN"]
    photos_slideshow(uri)
 	end

  def next_photos_slideshow
    if !@next_url.nil?
      uri = @next_url
      photos_slideshow(uri)
    end
  end

	def profile
		open_uri = "https://api.instagram.com/v1/users/" +
                  @photostream.uid + "/?access_token=" +
                  ENV["INSTAGRAM_ACCESS_TOKEN"]
  	response = open(open_uri).read
  	parse = JSON.parse(response)
  	jsonResults = parse["data"]
  	
    return jsonResults
  end

  def news_bar

    news_uri = "https://api.cognitive.microsoft.com/bing/v5.0/news/search?q=" + @photostream.feed1 + "&count=50&mkt=en-us&subscription-key=" + ENV["BING_ID"]

    response = open(URI.escape(news_uri)).read
    parse = JSON.parse(response)

    jsonResults = parse["value"]            # name, url, image (.thumbnail.contentUrl), description, datePublished

    return jsonResults
  end

  def counts
    media_uri = "https://api.instagram.com/v1/users/" + @photostream.uid + "/?access_token=" + ENV["INSTAGRAM_ACCESS_TOKEN"]
    response = open(URI.escape(media_uri)).read
    parse = JSON.parse(response)

    jsonResults = parse["data"]["counts"]

    return jsonResults
  end

  def follow
    follows_uri = "https://api.instagram.com/v1/users/self/follows?access_token=" + ENV["INSTAGRAM_ACCESS_TOKEN"]
    response = open(follows_uri).read
    parse = JSON.parse(response)
    jsonResults = parse["data"]

    return jsonResults
 	end
end
