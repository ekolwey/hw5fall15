# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^""]*)"$/ do |text|
    expect(page).to have_content(text)
 end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these
# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    # Each returned movie will be a hash representing one row of the movies_table
    # The keys will be the table headers and the values will be the row contents.
    # Entries can be directly to the database with ActiveRecord methods
    # Add the necessary Active Record call(s) to populate the database.
    
    Movie.create!(movie)
    
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and check/uncheck the ratings
  # using the appropriate Capybara command(s)
  
  ratings = arg1.split(%r{,\s*})
  
  uncheck('ratings_G')
  uncheck('ratings_PG')
  uncheck('ratings_PG-13')
  uncheck('ratings_NC-17')
  uncheck('ratings_R')
  
  ratings.each {|rating| 
    check("ratings_#{rating}")
  }
  
end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
  
  result = false;
  ratings = arg1.split(%r{,\s*})
  
  ratings.each { |rating|
  all("td").each do |td|
    if td.has_content?(rating)
      result = true;
    else
      result = false;
    end
  end
  }
  
  expect(result).to be_truthy
  
end

Then /^I should see all of the movies$/ do
  numRows = 0
  
  all("tr").each do |tr|
    numRows += 1
  end
  
  numRows.should == 11
  
end

When /^I have opted to sort movies alphabetically$/ do
  click_link("Movie Title")
end

Then /^I should see "(.*?)" before "(.*?)"$/ do |movie1, movie2|
  #pending
  
  first_m = 0
  alphabetic = false
  
  all("td").each do |td|
    if td.has_content?(movie1)
      first_m = 1
    end
    if first_m == 1
      if td.has_content?(movie2)
        alphabetic = true
      end
    end
  end
  
  expect(alphabetic).to be_truthy
  
end

When /^I have opted to sort movies in increasing order of release date$/ do
  click_link("Release Date")
end

#Then /^I will find "(.*?)" before "(.*?)"$/ do |movie1, movie2|
#  first_m = 0
#  release = false
  
#  all("td").each do |td|
#    if td.has_content?(movie1)
#     first_m = 1
#    end
#    if first_m == 1
#      if td.has_content?(movie2)
#        release = true
#      end
#    end
#  end
  
#  expect(release).to be_truthy
#end

