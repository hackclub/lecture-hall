# Lecture Hall [![CircleCI](https://circleci.com/gh/hackclub/lecture-hall.svg?style=svg)](https://circleci.com/gh/hackclub/lecture-hall)

Lecture Hall is our custom workshop viewer that'll soon be available at https://workshops.hackclub.com. It takes the content from [`hackclub/hackclub`](https://github.com/hackclub/hackclub) and makes it beautiful and extra easy to access.

The project's goals are threefold:

- Improve accessibility of workshops (ex. have open all links in new tabs by default)
- Improve accessibility of our community (ex. through an embedded Slack client)
- Better track engagement of our users through integration with analytics tools

## Setup

Lecture Hall is developed using [Docker Compose](https://docs.docker.com/compose/). If you don't already have it installed, do that now.

Start by cloning the repository recursively so you get all submodules.

    $ git clone --recursive git@github.com:hackclub/lecture-hall.git

And then start the app!

    $ docker-compose up

Finally, create the database and run migrations:

    $ docker-compose run web rails db:create
    $ docker-compose run web rails db:migrate

That's it!

### Installing Gems

Lecture Hall is configured to store all installed gems in a separate volume called `bundle`. If you want to install a new gem, just add it to `Gemfile` and then run the following command to get it installed.

    $ docker-compose run web bundle

## License

See [`LICENSE`](LICENSE).
