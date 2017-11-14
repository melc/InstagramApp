# InstagramApp

InstagramApp is a small instagram app for user to view most recent 220 media from instagram based on specific tags.  User can click on "follow", "like" buttons on your company site in lieu of instagram site. This app also allows user to view your company's recent news, information on number of your company's photos, followers and following.  The application is written in Ruby on Rails 4.

## Technical Features

include: 

- Ruby on Rails 4
- Devise 3.2.2
- Turbolinks
- Cancan 1.6.10
- Rolify 3.2.0
- Sqlite3
- MongoDB
- Omniauth
- Omniauth-instagram
- Instagram
- Backbone.js
- AWS EC2 and S3
- Amazon Simple Email Service
- Twitter Bootstrap 3.0.2
- Bootswatch for Rails 4
- BxSlider
- jQuery 1.10.2
- Let's Encrypt

## Functional Features 
### Authenticated User Management
- Login validation with unique email and customized password format
- Lock out user if exceed certain amount of attempts, unlock after reset account
- Send account confirmation request to new user's registered email account
- Activate user's account on confirmation of email address
- Allow user change password and update account info.
- Allow user create personal profile and upload profile photo
- Set user access level for different resources pages
- Set SSL(https)
- Set reCAPTCHA for sign in exceeds 2 times
- Allow user directly login to facebook and twitter

### Instagram App
- Display recent 220 media for specific tag(s) in carousel style
- Click on photo to view bigger photo and its owner's information on instagram site
- Autoscroll company's rss news 
- Count number of company's instagram media, followers and followings
- Click on button "search" to open inputbox for searching 220 media based on specific tags
- Click on button "follow" to allow user follow your company on instagram
- Click on button "like" to allow user like the media on instagram
- Click on button "comment" to allow user comment the media on instagram

***
![Instagram App Home Page](https://instagramapp.clappaws.cc/instagram.png)

