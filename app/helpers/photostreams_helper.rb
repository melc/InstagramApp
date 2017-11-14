module PhotostreamsHelper

  def valid_json?(response)
    begin
      !!JSON.parse(response)
    rescue JSON::ParserError
      false
    end
  end

  def check_http( uri_str, parse_val_1, parse_val_2 )

    response = Net::HTTP.get_response(URI.parse(uri_str))
    if ["400", "401", "402", "403", "404"].include? response.code
      render json: {message: "Error code: " + response.code + " - Access denied. Try later.."}

    elsif ['500', '502', '503', '504'].include? response.code
      render json: {message: "Error code: " + response.code + " - Server Error. Contact ClapPaws support.."}
    else
      parse = JSON.parse(response.body)

      if parse_val_2.nil?
        jsonResults = parse[parse_val_1]
      else
        jsonResults = parse[parse_val_1][parse_val_2]
      end

      return jsonResults

    end
  end

  def photos_count
    tag_count_uri = "https://api.instagram.com/v1/tags/" + @photostream.tag1 +
        "?access_token=" + ENV["INSTAGRAM_ACCESS_TOKEN"] + "&scope=public_content"

    return check_http(tag_count_uri, "data", nil)
  end

	def photos_slideshow(uri)

    jsonNextResults = check_http(uri, "pagination", nil)

    @next_url = jsonNextResults["next_url"] unless jsonNextResults.nil?

    response = Net::HTTP.get_response(URI.parse(uri))
    parse = JSON.parse(response.body)

    return  parse["data"]

  end

  def first_photos_slideshow
  	uri = "https://api.instagram.com/v1/tags/" + @photostream.tag1 + "/media/recent?access_token=" +
        ENV["INSTAGRAM_ACCESS_TOKEN"]
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

    return check_http(open_uri, "data", nil)
  end

  def news_bar

    news_uri = "https://api.cognitive.microsoft.com/bing/v7.0/search?q=" + ENV["INSTAGRAM_FEED"] + "&count=50&mkt=en-us&subscription-key=" + ENV["BING_ID"]

    return check_http(news_uri, "webPages", "value")

  end

  def counts
    media_uri = "https://api.instagram.com/v1/users/" + @photostream.uid + "/?access_token=" + ENV["INSTAGRAM_ACCESS_TOKEN"]

    return check_http(media_uri, "data", "counts")

  end

  def follow
    follows_uri = "https://api.instagram.com/v1/users/self/followed-by?access_token=" + ENV["INSTAGRAM_ACCESS_TOKEN"]

    return check_http(follows_uri, "data", nil)
 	end
end
