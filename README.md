# Trimet GTFS-Realtime Experimentation

Attempting to talk to [Trimet's GTFS-Realtime API](http://developer.trimet.org/GTFS.shtml) using ruby.

You'll need to put a in realtime.rb [TriMet AppID](http://developer.trimet.org/registration/), to connect to the service.

Parses and outputs most necessary data as JSON, this has been deployed on appfog at (http://gtrb.aws.af.cm/?appID=), simply pass in you appID from trimet
GEM file is already created for deploy
**FOR THE RECORD I DON'T KNOW RUBY, THE JSON OUTPUT DOES NOT USE ARRAYS BUT NUMBERS FOR EACH TRIP, THIS IS WRONG BUT IT WAS QUICK, SUBMIT A PULL REQUEST AND FIX IT IF YOU CARE**
```
bundle install
af push someappname
```