# Tiny URL

## Functional Requirements
- Encoded url into a short URL and that the short URL can be decoded back into the original URL
- Only accept JSON as body input and response JSON format following JSONAPI standard
- The shortened value must be less than 6 characters not including special ones.
- Provide tests
- The service will serve continuously for a few numbers of users (max 2 - 5 requests per second), however it need to have good performance

## Non Functional Requirements
- Readability
- Unpredictability

## TODO
- [] Add tests

## Enhancements
- Pre-generate short URLs
