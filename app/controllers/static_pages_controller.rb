class StaticPagesController < ApplicationController
    def home
        @photo = Photo.all 
    end
end
