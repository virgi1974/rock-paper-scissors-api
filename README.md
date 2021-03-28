# ROCK-PAPER-SCISSORS 🪨 🧻 ✂️

API to play rock-paper-scissors.  
The idea is to have a simple interface.

- **GET /games** [endpoint to retrieve the history of games stored in DB]
- **POST /games** [endpoint to play against a Bot(random movement generator)]

### Dependencies

To ease the Postgress DB setup I chose a full Dockerized app version instead of a local setup, with these dependencies

- Ruby version. 2.7.0
- Rails version. 6.1.3
- Database Postgress

The chosen framework for Ruy has been Rails due to the ease of using it in API only mode.  
The only required software to run the app is `Docker`.

### Installation

We need first to clone the repo and then follow the steps to get the full app and DB running in containers.

1. Install Docker
2. Run `docker-compose up`. This will start two containers where the DB and the app will be running.  
   It is gonna take some time the first time since it has to download images for both Ruby and Postgress, and install all the dependencies.
3. Once it is finished we have to get the container id related to the image we are using with something like  
   `docker ps | grep rock-paper-scissors-api_web`
4. We can then run a shell in that container  
   `docker exec -it 180945e859a7 sh`  
   and once inside trigger the db Rails setup commands  
   `rails db:create && rails db:migrate`  
   **OR** execute directly via the command line with  
   `docker exec -it 180945e859a7 bundle exec rails db:migrate`
5. There is a `seeds.rb` file to populate the DB.
6. We should be able to access the app via the port `3000`.  
   In case some error happens we can stop running containers `docker-compose down` and then try  
   `docker-compose run --rm -p 3000:3000 web bundle exec rails s -b 0.0.0.0`

NOTE
Every time we add dependencies to the project we need to build images again `docker-compose up --build` to bundle install the related dependency.

### Data

Basic data to populate database can be found in the file `seeds.rb`.

### DB Modelling

**Game** - holds the data of a game (user movement, bot movement, creation time, user)  
**User** - just with a `name` uniq field

Because not Authentications was included as part of the exercice, we chose to have a uniq `name` field for the User model, so different users with same name won't collide when playing.\
As mentioned before it should be improved with an Authentication system.

### Usage

The different endpoints can be tested via Postman or any other Http client.

In the `routes.rb` file the different routes of the project can be seen in detail.  
Api versioning has been used from the beginning, so all routes should use prefix `/api/v1`  
There are 2 endpoints

        GET /api/v1/games  To get all games (games history)
        POST /api/v1/games To play (create a game)

The json structure for the history **GET /games** was not given as part of the exercice requirements so we chose this one

```
{
    "total_games": 21,
    "page": 1,
    "results_per_page": 5,
    "games": [
        {
            "username": "Thomas",
            "user_movement": "rock",
            "bot_movement": "paper",
            "result": "loses",
            "played_at": "03/28/2021 - 02:59PM"
        }
        ...
```

The json structure for the **POST /games** has been done following the example in the exercice requirements

```
{
    "moves": [
        {
            "name": "Thomas",
            "move": "rock"
        },
        {
            "name": "Bot",
            "move": "paper"
        }
    ],
    "result": "Thomas loses"
}
```

We added a generic response for cases where game creation fails

```
{
    "errors": {
        "message": "User movement is not included in the list"
    }
}
```

### Testing

The test suite can be run by using the command **`bundle exec rspec`** on the running `web` service container
`docker exec -it 6e1c8037e846 bundle exec rspec`

### Linters

Rubocop has been used to keep consistency in the code base.  
It can be run with `docker exec -it 6e1c8037e846 bundle exec rubocop`

#### How would you improve your solution? What would be the next steps?

- Adding swagger
- I created the app as a Rails project in API mode, BUT it still added many extra modules that are not needed and add a lot of content in the logs (Thinking of ActionCable). The app scafold should have been done removing those uneeded modules.
- Authentication.
- Indexing of the DB once we know the queries to be done
- Authorization (though is not key since we don't expose SHOW actions with specific id's).
