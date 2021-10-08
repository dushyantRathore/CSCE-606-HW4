class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    # Get all the movie ratings (unique)
    @all_ratings = Movie.select(:rating).map(&:rating).uniq

    # Update the session variables if params are supplied
    if params[:sort]
      session[:sort] = params[:sort]
    end
    
    if params[:ratings]
      session[:ratings] = params[:ratings]
    end
    
    # Update the sorting-on-column check
    @sorting_on_column = session[:sort]
    
    # Check if ratings are defined and handle accordingly
    session[:ratings] ||= @all_ratings
    
    # Reference the responses going to the view
    @ratings = session[:ratings]
    
    # Extract the keys from the updated ratings
    @ratings = @ratings.keys if @ratings.respond_to?(:keys) 

    if session[:sort] != params[:sort] || session[:ratings] != params[:ratings] # Not containing the right parameters
      # Store the additional flash before the redirect
      flash.keep
      redirect_to movies_path(sort: session[:sort], ratings: session[:ratings])
    end

    @movies = Movie.where("rating IN (?)", @ratings).order(session[:sort])

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  # Controller method to fetch similar movies
  def similar
    @movie = Movie.find params[:id]
    if((@movie.director.nil?) or (@movie.director == ""))
      flash[:warning ] = "'#{@movie.title}' has no director info"
      redirect_to movies_path
    end
    @movies = Movie.where(director: @movie.director).where.not(title: @movie.title)
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :director)
  end
end
