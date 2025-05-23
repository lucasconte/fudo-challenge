# Fudo Challenge

This is a simple Rack-based Ruby API for user authentication and product management. It includes features like JWT-based authentication, asynchronous background jobs using Sidekiq, gzip compression, and OpenAPI (Swagger) documentation.

## Requirements

- Docker
- Docker Compose

## How to Start the Application

1. Clone this repository:

   ```bash
   git clone https://github.com/lucasconte/fudo-challenge.git
   cd your-repo
   ```

2. Start the application using Docker Compose:

   ```bash
   docker-compose up --build
   ```

3. The application will be available at:  
   [http://localhost:9292](http://localhost:9292)

## API Documentation (Swagger)

To view and interact with the API using Swagger UI:

1. Make sure the app is running (`docker-compose up`).
2. Visit the following URL in your browser:  
   [http://localhost:8080](http://localhost:8080)

## Additional Notes

- The API returns responses compressed with Gzip when requested via `Accept-Encoding: gzip`.
- Authorization is required to access `/products` endpoints. Obtain a JWT token from `/login`, then include it as a `Bearer` token in the `Authorization` header. (in case of Swagger, you need to include the token in the 'Authorize' button)
- An `AUTHORS` file is exposed at the root at `/AUTHORS` and is cached for 24 hours.
