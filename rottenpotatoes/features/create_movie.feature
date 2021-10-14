Feature: Create a movie

  As a movie buff
  So that I can add new movies
  I want to have the functionality to add new movies

Background: movies in database

  Given the following movies exist:
  | title        | rating | director     | release_date |
  | Star Wars    | PG     | George Lucas |   1977-05-25 |
  | Blade Runner | PG     | Ridley Scott |   1982-06-25 |
  | Alien        | R      |              |   1979-05-25 |
  | THX-1138     | R      | George Lucas |   1971-03-11 |

Scenario: add a new movie
  When I go to the create movie page
  And  I fill in "Title" with "Interstellar"
  And  I fill in "Director" with "Christopher Nolan"
  Then I press "Save Changes"
  Then I should be on the home page
  And  I should see "Interstellar"