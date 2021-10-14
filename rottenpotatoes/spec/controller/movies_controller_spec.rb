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

RSpec.describe MoviesController, type: :controller do
    
    describe "index" do
        it "Should display the index template" do
            get :index
            expect(response).to redirect_to(movies_path)
        end
    end

    describe "create" do
        it "Should create a new movie with the provided parameters" do
            @movie = double().as_null_object
            expect(Movie).to receive(:create!).and_return(@movie)
            post :create, :movie => {:title => "Fast and the Furious 9", :rating => "PG-13", :director => "Justin Lin", :description => "", :release_date => "2021-06-25"}
            expect(response).to redirect_to(movies_path)
        end
    end

    describe "show" do
        it "Should display the details of a movie using the provided id" do
            @movie=double(:title => "Star Wars", :rating => "PG", :director => "George Lucas", :description => "", :release_date => "1977-05-25", :id => 11)
            expect(Movie).to receive(:find).and_return(@movie)
            get :show, :id => @movie.id
            expect(response).to render_template(:show)
        end
    end

    describe "edit" do
        it "Should privde the edit option for a movie given the id" do
            @movie=double(:title => "Star Wars", :rating => "PG", :director => "George Lucas", :description => "First movie of the Star Wars series", :release_date => "1977-05-25", :id => 11)
            expect(Movie).to receive(:find).and_return(@movie)
            get :edit, :id => @movie.id
            expect(response).to render_template(:edit)
        end
    end

    describe "update" do
        it "Should update the details of a movie given the id" do
            @movie=double(:title => "Fast and the Furious 9", :rating => "PG-13", :director => "Denis Villeneuve", :description => "", :release_date => "2021-06-25", :id => 11).as_null_object
            @new_params={:title => "Fast and the Furious 8", :rating => "PG-13", :director => "F. Gary Gray", :description => "8th edition of the Fast and Furios series", :release_date => "2017-04-14"}
            expect(Movie).to receive(:find).and_return(@movie)
            put :update, :id => @movie.id, :movie => @new_params
            expect(response).to redirect_to(movie_path(@movie))
        end
    end

    describe "destroy" do
        it "Should delete the movie given the id" do
            @movie=double(:title => "Star Wars", :rating => "PG", :director => "George Lucas", :description => "First movie of the Star Wars series", :release_date => "1977-05-25", :id => 11)
            expect(Movie).to receive(:find).and_return(@movie)
            expect(@movie).to receive(:destroy)
            delete :destroy, :id => @movie.id
            expect(response).to redirect_to(movies_path)
        end
    end

    describe "similar" do
        it "Should find movies with the same director" do
            @movie=double(:id=> 11, :title => "Star Wars", :director => "George Lucas")
            expect(Movie).to receive(:find).and_return(@movie)
            get :similar, :id => @movie.id
            expect(response).to render_template(:similar)
        end
        it "Should redirect to the movies page" do
            @movie_id = "1234"
            @movie=double().as_null_object
            expect(Movie).to receive(:find).with(@movie_id).and_return(@movie)
            get :similar, :id => @movie_id
            expect(response).to render_template(:similar)
        end
    end

    describe "new" do
        it "Should show the new template" do
            get :new
            expect(response).to render_template(:new)
        end
    end

end