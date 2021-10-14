require "rails_helper"

if RUBY_VERSION>="2.6.0"
    if Rails.version < "5"
      class ActionController::TestResponse < ActionDispatch::TestResponse
        def recycle!
          # hack to avoid MonitorMixin double-initialize error:
          @mon_mutex_owner_object_id = nil
          @mon_mutex = nil
          initialize
        end
      end
    else
      puts "Monkeypatch for ActionController::TestResponse no longer needed"
    end
end

describe Movie do

    describe "#similar" do
        
        it "Should find movies by the same director" do
            movie1 = Movie.create! :director => "George Lucas"
            movie2 = Movie.create! :director =>  "George Lucas"
            expect(movie1.similar).to include(movie2)
        end 
        
        it "Should find movies by different directors" do
            movie1 = Movie.create! :director => "George Lucas"
            movie2 = Movie.create! :director => "Ridley Scott"
            expect(movie1.similar).not_to include(movie2)
        end 
        
    end
end