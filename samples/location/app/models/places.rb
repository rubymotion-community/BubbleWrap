class Places
  API_KEY = ""
  #See google places documentation at https://developers.google.com/places/documentation/ to obtain a key

  def self.load(places_list_controller)
    BW::Location.get do |result|
      BW::Location.stop
      BubbleWrap::HTTP.get("https://maps.googleapis.com/maps/api/place/search/json?location=#{result[:to].latitude},#{result[:to].longitude}&radius=500&sensor=false&key=#{API_KEY}") do |response|
        names = BW::JSON.parse(response.body.to_str)["results"].map{|r| r["name"]}
        places_list_controller.places_list = names  
        places_list_controller.reloadData
      end
    end
  end
end
