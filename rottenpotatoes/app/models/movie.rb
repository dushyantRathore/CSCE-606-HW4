class Movie < ActiveRecord::Base
    def similar
        Movie.where("director =?", self.director)
      end
end