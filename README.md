codepath-rottentomatoes
=======================

Rotten Tomatoes

* Time to complete 13 hours

Stories Completed:-
* [x] Required: User can view a list of movies from Rotten Tomatoes. Poster images must be loading asynchronously.
* [x] Required: User can view movie details by tapping on a cell 
* [x] Required: User sees loading state while waiting for movies API. You can use one of the 3rd party libraries at cocoacontrols.com.
* [x] Required: User sees error message when there's a networking error. You may not use UIAlertView to display the error. See this screenshot for what the error message should look like: network error screenshot.
* [x] Required: User can pull to refresh the movie list.
* [x] Optional: All images fade in.
* [x] Optional: For the large poster, load the low-res image first, switch to high-res when complete.
* [x] Optional: Customize the highlight and selection effect of the cell.
* [x] Optional: Customize the navigation bar.
* [x] Optional: Add a search bar.

Other Libraries Used:
* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* [MBProgressHUD] (https://github.com/jdg/MBProgressHUD)
* [MBLMessageBanner] (https://github.com/Loadex/MessageBanner)

The app leverages the [Box Office Movies API](http://developer.rottentomatoes.com/docs/read/json/v10/Box_Office_Movies) which returns the following JSON response:

```json
{
  "movies": [{
    "id": "770687943",
    "title": "Harry Potter and the Deathly Hallows - Part 2",
    "year": 2011,
    "mpaa_rating": "PG-13",
    "runtime": 130,
    "critics_consensus": "Thrilling, powerfully acted, and visually dazzling...",
    "release_dates": {"theater": "2011-07-15"},
    "ratings": {
      "critics_rating": "Certified Fresh",
      "critics_score": 97,
      "audience_rating": "Upright",
      "audience_score": 93
    },
    "synopsis": "Harry Potter and the Deathly Hallows, is the final adventure...",
    "posters": {
      "thumbnail": "http://content8.flixster.com/movie/11/15/86/11158674_mob.jpg",
      "profile": "http://content8.flixster.com/movie/11/15/86/11158674_pro.jpg",
      "detailed": "http://content8.flixster.com/movie/11/15/86/11158674_det.jpg",
      "original": "http://content8.flixster.com/movie/11/15/86/11158674_ori.jpg"
    },
    "abridged_cast": [
      {
        "name": "Daniel Radcliffe",
        "characters": ["Harry Potter"]
      },
      {
        "name": "Rupert Grint",
        "characters": [
          "Ron Weasley",
          "Ron Wesley"
        ]
      }
    ]
  }, 
  {
     "id": "770687943",
     ...
  }]
}
```

![alt tag](http://imgur.com/ov5RK0y)

GIF created with [LiceCap](http://www.cockos.com/licecap/).
