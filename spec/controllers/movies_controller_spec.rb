require	'spec_helper'	
require	'rails_helper'


describe MoviesController do	
	describe 'searching	TMDb' do
		before :each do
			@fake_results = [double('movie1'), double('movie2')]
		end
		
		it 'should call the model method that performs TMDb search'	do
			expect(Movie).to receive(:find_in_tmdb).with('Ted').and_return(@fake_results)	
			post :search_tmdb, {:search => {:search_Tmdb => 'Ted'}}	
		end	
		
		it 'should select the Search results template for rendering' do
		    allow(Movie).to receive(:find_in_tmdb)
		    post :search_tmdb, {:search => {:search_Tmdb => 'Ted'}}
		    expect(response).to render_template('search_tmdb')
	    end
		
		it 'should make the TMDb results available to that template' do
			allow(Movie).to receive(:find_in_tmdb).and_return(@fake_results)
			post :search_tmdb, {:search => {:search_Tmdb => 'hardware'}}
			expect(assigns(:matching_movies)).to eq @fake_results
		end
		
		it 'should not call model method if params are empty' do 
		    expect(Movie).not_to receive(:find_in_tmdb).with('')
		    post :search_tmdb, {:search => {:search_Tmdb => ''}}
		    expect(response).to redirect_to("/movies")
		end
		
		it 'should indicate that no movies are available if no matches are found' do
			fake_results = ""
			allow(Movie).to receive(:find_in_tmdb).and_return(fake_results)
			post :search_tmdb, {:search => {:search_Tmdb => 'Ted'}}
			expect(flash[:notice]).to eql("No matching movies were found on TMDb")
			expect(response).to redirect_to("/movies")
		end
	end	
	
	describe 'add_tmdb' do
		it 'should call the model method that adds movie to database' do
			expect(Movie).to receive(:create_from_tmdb)
			post :add_tmdb, {:tmdb_movies => {:id => 'Ted'}}
		end
		
		it 'should flash message for successful creation and return to homepage' do
			allow(Movie).to receive(:create_from_tmdb)
			post :add_tmdb, {:tmdb_movies => {:id => 'Ted'}}
			expect(flash[:notice]).to eql("Movies successfully added to Rotten Potatoes")
			expect(response).to redirect_to("/movies")
		end
		
		it 'should return to homepage if no movies selected' do
			post :add_tmdb, {:tmdb_movies => nil}
			expect(flash[:notice]).to eql("No movies selected")
			expect(response).to redirect_to("/movies")
			end
		
	end
	
	
end	