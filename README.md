# Achieve
An iOS application that connects underrepresented groups to educational and job opportunities.

## Audience
Underrepresented groups in the education and/or job industry.

## Experience
A user is prompted to lo in with an email and is then taken to the Search page. The search page will act as sort of the home view as well as where internships and scholarships are displayed, and it will also contain a tab bar controller that can take the user to a favorited opportunities page or their profile.

# Technical
## Storyboards
Main - Where I put all my views

## Models
Colors - UIColors for views

OpportunitiesModel - includes model for internships and scholarships


## Views
UIView+Extension - setGradientBackground to customize views

FavoriteCells - Opportunities that have been favorited, including their properties

SearchViewControllerCell - Cell that's displayed in

## Controllers
FirstViewController - The first screen a new or returning user will see before logging in

LoginViewController - Returning users come here to login to their existing account then will be brought to the Search view

RegisterViewController - New users come here to create an account then will be brought to the Search view

SearchViewController - The main view where the user can browse opportunities

FavoritesViewController - Where all the user's favorited opportunities  will appear

ProfileViewController - Displays users email used to sign in, ability to logout here

InternshipDetailsViewController - Includes the description of selected internship and allows user to find out more information by bringing them to provider's website

ScholarshipDetailsViewController - Includes the description of selected scholarship and allows user to find out more information by bringing them to provider's website

PopupViewController - Popup when user presses favorite button

## Pods
Firebase

FirebaseAuth

FirebaseDatabase

## Other
### Attributions

Icons from https://icons8.com/
