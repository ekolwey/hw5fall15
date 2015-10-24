class Movie < ActiveRecord::Base
  
  class	Movie::InvalidKeyError	<	StandardError	;	end
  
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
  
  def self.find_in_tmdb movie_title
    
    @match_movies = Tmdb::Movie.find(movie_title)
    @match_movie_array = Array.new
      
    if @match_movies.nil?
      @match_movie_array = []
    else
      @match_movies.each do |movie|
        match_movie = {"tmdb_id" => movie.id, "title" => movie.title, "rating" => "PG", "release_date" => movie.release_date}
        @match_movie_array << match_movie
      end
    end
    
    return @match_movie_array
  end
  
  
  def self.create_from_tmdb movie_id
    @details = Tmdb::Movie.detail(movie_id)
    
    if !@details.nil?
      title = @details["title"]
      release_date = @details["release_date"]
      description = @details["overview"]
      new_movie = {"title" => title, "rating" => "PG", "release_date" => release_date, "description" => description}
      Movie.create!(new_movie)
    end
  end
  

end
