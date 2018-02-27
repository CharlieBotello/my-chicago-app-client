require 'unirest'
require 'paint'
require_relative 'controllers/products_controller'
class Frontend
  include LocationsController
  def run 
 
    while true 
      system "clear"

      puts "        Welcome to my Chicago History App"
      puts ""
      puts "          [1] Show all locations"
      puts "              [1.1] Search all locations"
      puts "              [1.2] Sort all locations by name"
      puts "              [1.3] Sort all locations by year"

      puts "          [2] Show one location "
      puts "          [3] Create a location "
      puts "          [4] Update a location "
      puts "          [5] Destroy a location "
      puts "          [6] Show all User Locations "

      puts
      puts "          [signup] Signup to (create a user) "
      puts "          [login] Login (ceate JSON web token)"
      puts "          [logout] Logout (erase JSON web token)"


      puts "          [q] Enter 'q' to quit "



      

      input_option = gets.chomp 

      

      if input_option == '1'
        locations_index_action
      elsif input_option == '1.1'
        locations_search_action

      elsif input_option == '1.2'
        response = Unirest.get("http://localhost:3000/locations/?sort=name")
        locations = response.body
        puts JSON.pretty_generate(locations)

      elsif input_option == '1.3'
        response = Unirest.get("http://localhost:3000/locations/?sort=year")
        locations = response.body
        puts JSON.pretty_generate(locations)

      elsif input_option == '2'
        locations_show_action
        
      elsif input_option == '3'
        locations_create_action

      elsif input_option == '4'
        locations_update_action
      elsif input_option == '5'
       locations_destroy_action
      elsif input_option == '6'
        user_locations_hashs = Unirest.get("http://localhost:3000/user_locations")   
        puts JSON.pretty_generate(user_locations_hashs)     

      elsif input_option == 'signup'
        puts "Signup for a  new account"
        puts 
        puts client_params = {}
        print "Name: "
        client_params[:name] = gets.chomp

        print "Email: "
        client_params[:email] = gets.chomp

        print "Password: "
        client_params[:password] = gets.chomp

        print "Password confirmation: "
        client_params[:password_confirmation] = gets.chomp
        response = Unirest.post("http://localhost:3000/users", parameters: client_params)
        
        puts JSON.pretty_generate(response.body) 
            
      elsif input_option == 'login'
        puts "Login"
        puts
        puts "Email: "
        input_email = gets.chomp

        puts "Password: "
        input_password = gets.chomp

        response = Unirest.post(
                                "http://localhost:3000/user_token",
                                parameters: {
                                              auth: {
                                                      email: input_email,
                                                      password: input_password
                                                    }
                                            }

                                )
        puts JSON.pretty_generate(response.body)
        jwt = response.body["jwt"]
        Unirest.default_header("Authorization", "Bearer #{jwt}")
      elsif input_option == 'logout'
        jwt = ""
        Unirest.clear_default_headers
        puts "you are logged out"
          
      elsif input_option == 'q'
        puts "Goodbye, thanks for stopping by"
        exit 
      end
      gets.chomp 
    end
  end    
end
