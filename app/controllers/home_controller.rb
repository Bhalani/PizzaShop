class HomeController < ApplicationController
  def index
    if logged_in?
      if current_role == "vendor"
        redirect_to vendors_home_path
      else
        redirect_to customers_home_path
      end
    end
  end
end
