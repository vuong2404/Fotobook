class HomeController < ApplicationController
  def feed
    @photos = Photo.all 
    @albums = Album.all

  end

  def discovery
  end
end
