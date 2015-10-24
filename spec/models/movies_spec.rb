require	'spec_helper'	
require	'rails_helper'	

describe Movie do
    describe 'find_in_tmdb' do
        context 'with valid key' do
            before :each do
        		expect(Tmdb::Movie).to receive(:find).with("Hercules")
        	end
            it 'should call TMDb with title keyword' do
        		Movie.find_in_tmdb("Hercules")
            end
                
            it 'should return an array from the TMDb search' do
                expect(Movie.find_in_tmdb("Hercules")).to be_an_instance_of(Array)
            end
        end
            
        context 'with invalid key' do
            it 'should return an empty array if no matches were found' do
                expect(Tmdb::Movie).to receive(:find).with("")
                expect(Movie.find_in_tmdb("")).to be_empty
            end
        end
        
    end
    
    describe 'create_from_tmdb' do
        it 'should call TMDb detail with id code' do
            expect(Tmdb::Movie).to receive(:detail)
            Movie.create_from_tmdb('hardware')
        end
        
        it 'should call the created method on a valid movie' do
            expect(Movie).to receive(:create!)
            Movie.create_from_tmdb('hardware')
        end
        
    end
end