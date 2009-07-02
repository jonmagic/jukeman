module LocationsHelper
  def last_polled_at_helper(location)
    if location.polled_at != nil
      location.polled_at.strftime("%h:%m:%s, %m-%d-%Y")
    else
      "never"
    end
  end
  
end
