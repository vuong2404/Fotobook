class Photo < ApplicationRecord
    before_create :set_default_value
  
    validates :sharing_mode , exclusion: {in: %w(private public), message: "Sharing mode must be private or public" }
    
    private
    
    def set_default_value
        self.sharing_mode = 'private'
        self.description = ''
        self.title = ''
    end
end
