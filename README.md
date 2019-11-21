# REDMINER METRICIZER!

### What it is...

This is a tool for generating metrics out of your Redmine issues. 

Right now, it's mainly targeting the number of Cycletime. 

### What you'll need...

An `API KEY`. You can get it by going to the settings and generating a new `API KEY`. It should look like this...

    BbLjOW1TMnA4ylF6bIr8GRKSbeVxPyQzGw8PdNiJ

### To run this...

    $ bundle exec ruby app.rb > output.csv

### Now you'll have...

An output file called `output.csv` that will contain the `issue id`, 'link' `title`, and a series of columns for each status.

That can then be uploaded into Actionable Agile for forecasting and what-nots.
