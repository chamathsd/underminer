##Underminer

"I am always beneath you, but nothing is beneath me!" - The Underminer, Incredibles (2004)

### What it is...

This is a tool for generating metrics out of your Redmine issues. 

Right now, it's mainly targeting the number of Cycletime. 

### What you'll need...

An `API KEY`. You can get it by going to the settings and generating a new `API KEY`. It should look like this...

    BbLjOW1TMnA4ylF6bIr8GRKSbeVxPyQzGw8PdNiJ


### Run the underminer

You'll also need a place to run it and since Ruby is a pain to install and maintain unless you're a regular Ruby dev. Use *docker*.

```
$ docker pull ruby
```

Use the Ruby docker container to run the app.

```
docker run  --rm -it -v $(pwd):/app ruby /bin/bash
root@...:/# gem install bundler:1.17.1
root@...:/# cd /app
root@...:/# bundle install
root@...:/# export UNDERMINER_API_KEY='... string from up top ...'
root@...:/# export UNDERMINER_BASE_URL='... url to redmine ...'
root@...:/# ./underminer

```

### See results

Running the app will generate a *cycletimes.csv* file. This will contain all the cycles times for all completed stories from Redmine. Go ahead and load it into your favorite analytics tool for fun graphs and such.

