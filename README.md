# Tiny URL

## Functional Requirements
- Encoded url into a short URL and that the short URL can be decoded back into the original URL
- Only accept JSON as body input and response JSON format following JSONAPI standard
- The shortened value must be less than 6 characters not including special ones.
- Provide tests
- The service will serve continuously for a few numbers of users (max 2 - 5 requests per second)

## Design
- TinyURL is a read-heavy service. To prevent data collision, I have decided to utilize a PostgreSQL database with a unique index created on the `slug` column. Additionally, we can establish replicated databases to enhance read performance.
- In order to ensure readability, I have chosen to use Base58 encoding, which avoids special characters as well as others that might confuse the client (eliminating the likes of '0' 'O' 'I' 'l'). The total number of short URLs possible is ( 58^6 ) (maximum characters) which equals 38,068,692,544 URLs. Assuming clients generate new short URLs at a rate of 50 requests per second, for 10 years, the total number of URLs created would be ( 50 \times 3600 \times 24 \times 365 \times 10 = 15,768,000,000 ) URLs. Therefore, the service should remain adequate for at least the next decade.    
- To avoid duplication and the need for re-rolling, I have decided on two methods to generate short URLs:    
    - The first approach involves using a UUID to create a URL record in the database and then converting this to hex.
    - The second approach is employed if the first method fails to generate a URL. In such cases, the system will inform the user that it is processing their request and will asynchronously re-roll the short URL in a background job to improve user experience. For this method, I will use SecureRandom to generate a hex.
- Redirection API: To improve performance, I am implementing low-level caching with Redis to store frequently accessed shortened URLs. 
- Future enhancements:
    - To safeguard the system, we can impose a rate limiter to ensure that a single user can only make 5 requests per second.
    - Another strategy for performance improvement is to set up an auxiliary service with an additional database to pre-generate unique `slug` entries. When client create new shorted url, we can get from service pre-generate quickly

## Demo
- Visit: `https://tiny-url.fly.dev`

## Install for development
- Run `rake secret`
- Run `rails credentials:edit`, add key `secret_key_jwt` with value from `rake secret`
- Run `docker compose build`
- Run `docker compose up`

## Deploy for production use fly.io
- Run `rails credentials:edit --environment production` and remember add key `secret_key_jwt`
- Ensure RAILS_MASTER_KEY is content of `config/credentials/production.key`
- Run `fly deploy`

## Enhancements
- [ ] Rate limiter
- [ ] Pre-generate short URLs
