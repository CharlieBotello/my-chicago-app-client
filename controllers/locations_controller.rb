module LocationsController
  def locations_index_action
    response = Unirest.get("http://localhost:3000/locations")
    locations = response.body 
    puts JSON.pretty_generate(locations) 
  end
  def locations_show_action
    print "Enter a location id: "
    input_id = gets.chomp
    response = Unirest.get("http://localhost:3000/locations/#{input_id}")
    location = response.body
    puts JSON.pretty_generate(location)

    puts "Press enter to continue or type 'o' to add the location to your planner"

    user_choice = gets.chomp
    if user_choice == 'o'
      print "Enter a start date to add to your planner (example January, 31 2017 12:30pm): "
      input_start = gets.chomp
      print "Enter an end time to your planner (example January, 31 2017 2:30pm): "
      input_end = gets.chomp

      client_params = {
                        start_time: input_start,
                        end_time: input_end,
                        location_id: input_id
                      }
      response_data = Unirest.post("http://localhost:3000/user_locations",  client_params)
      puts JSON.pretty_generate(response_data)
    end
  end

  def locations_create_action
    puts "Enter the following information to create a location"
    client_params = {}
    
    print "Name: "
    client_params[:name] = gets.chomp

    print "Address: "
    client_params[:address] = gets.chomp

    print "Latitude: "
    client_params[:latitude] = gets.chomp

    print "Longitude: "
    client_params[:longitude] = gets.chomp

    print "Year: "
    client_params[:year] = gets.chomp

    response = Unirest.post("http://localhost:3000/locations",
                                                              parameters: client_params

                            )
    # response = Unirest.post("http://localhost:3000/locations", parameters: client_params)
    if response.code == 200
      location = response.body 
      puts JSON.pretty_generate(location)
    else 
      errors = response.body 
      puts "Your location was not created: "
      puts "Here are the reasons why: "
      puts "==========================="
      errors.each do |error|
        puts error
      end 
    end
  end
  def locations_update_action
    puts 'Please enter an id: '
    input_id = gets.chomp
    response = Unirest.get("http://localhost:3000/locations/#{input_id}")
    location_json = response.body
    client_params = {}
    
    puts "Enter the following information to update location: "
    print "Name: (#{location_json["name"]}) "
    client_params[:name] = gets.chomp

    print "Address: (#{location_json["address"]})  "
    client_params[:address] = gets.chomp

    print "Latitude: (#{location_json["latitude"]}) "
    client_params[:latitude] = gets.chomp

    print "Longitude: (#{location_json["longitude"]}) "
    client_params[:longitude] = gets.chomp

    print "Year: (#{location_json["year"]}) "
    client_params[:year] = gets.chomp


    client_params.delete_if { |key, value| value.empty? }
      
    response = Unirest.patch("http://localhost:3000/locations/#{input_id}",
                                                                parameters: client_params
                            )
    if response.code == 200 
      updated_location = response.body 
      puts JSON.pretty_generate(updated_location)
    else 
      errors = response.body
      puts "Your location did not update "
      puts "Here are the reasons why: "
      puts "==========================="
      errors.each do |error|
        puts error
      end 
    end 
  end
  def locations_destroy_action
    print "Enter recipe Id: "
    input_id = gets.chomp
    response = Unirest.delete("http://localhost:3000/locations/#{input_id}")
    data = response.body
    puts data["message"]
  end
  def loacations_search_action
    print "Enter a search term: "
    search_term = gets.chomp
    response = Unirest.get("http://localhost:3000/locations/?search=#{search_term}")
    locations = response.body
    puts JSON.pretty_generate(locations)
  end
end 