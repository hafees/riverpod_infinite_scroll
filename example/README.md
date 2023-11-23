# example

An example project for demonstrating _Riverpod Infinite Scroll_ package.

## Getting Started

This project uses TMDB API. So, you will need a TMDB API key. After creating an account, you can request a free API key https://developer.themoviedb.org/docs/getting-started.

For security reasons, the API key is stored in an .env file and the _envied_ package is used to safely get the API key. Since the envied package needs to generate a file you will need to run the build_runner.

## Steps

- 1. Signup for an API key https://themoviedb.org
- 2. Copy the `.env copy` file and rename it to `.env`
- 3. Copy your API key. It will look like `TMDB_API_KEY=YOUR ACTUAL API KEY`
- 4. Now run the build runner to create `env/env.g.dart`
     `dart run build_runner watch`
     or
     `dart run build_runner build`

Note: You should run `build_runner` in the `example` folder.
`cd exammple`

Now you should be ready to start the project.
