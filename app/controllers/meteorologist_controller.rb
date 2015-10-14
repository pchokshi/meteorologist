require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]
    url_safe_street_address = URI.encode(@street_address)

    # ==========================================================================
    # Your code goes below.
    # The street address the user input is in the string @street_address.
    # A URL-safe version of the street address, with spaces and other illegal
    #   characters removed, is in the string url_safe_street_address.
    # ==========================================================================

    geo_url= "https://maps.googleapis.com/maps/api/geocode/json?address="+url_safe_street_address+"="
    parsed_data = JSON.parse(open(geo_url).read)
    latitude = parsed_data["results"][0]["geometry"]["location"]["lat"]
    longitude = parsed_data["results"][0]["geometry"]["location"]["lng"]

    @lat = latitude.to_s
    @lng = longitude.to_s

    forecast_url= "https://api.forecast.io/forecast/1535a9ec8de2ff52fb61e0b41cbf8b9b/"+@lat+","+@lng
    parsed_data = JSON.parse(open(forecast_url).read)
    current_temp = parsed_data["currently"]["temperature"]
    current_summary = parsed_data["currently"]["summary"]
    summary_sixty = parsed_data["minutely"]["summary"]
    summary_hours = parsed_data["hourly"]["summary"]
    summary_days = parsed_data["daily"]["summary"]

    @current_temperature = current_temp

    @current_summary = current_summary

    @summary_of_next_sixty_minutes = summary_sixty

    @summary_of_next_several_hours = summary_hours

    @summary_of_next_several_days = summary_days

    render("street_to_weather.html.erb")
  end
end
