# BookMe

## Description
BookMe is an app where clients can book appointments and service providers (such as hair stylists) can manage their appointments (bookings).

## Table of Contents
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Features
### General
- Search for businesses by name, location, and services.
- Schedule appointments at a business for a specific service.

### Business Owner
- Add business hours and services to a business profile.
- Manage bookings.
  - Add a booking for a specific client.
  - Accept and decline incoming bookings.
  - View a weekly calendar of bookings.

## Installation
### Prerequisites
- Ruby 3.x
- Rails 7.x
- PostgreSQL

### Steps
1. Clone the repository:
`git clone https://github.com/hatcheta1/book-me.git`

2. Install the required gems:
`bundle install`

3. Set up the database:
`rails db:setup`

4. Populate the database:
`rake sample_data`

5. Start the Rails server:
`bin/dev`

## Configuration
There are no configurations at the moment. If you would like to implement something of that nature, please refer to [Rails credentials documentation](https://edgeguides.rubyonrails.org/security.html).

## Usage
1. Start the Rails server:
`bin/dev`

2. Open your browser and navigate to http://localhost:3000

3. Sign up for an account to navigate client-specific views. From there, you can add a business to see the business owner-specific views. Or, log in with one of the following accounts to experience the app without creating an account: 

- Business Owner: `email: ashanti@example.com, password: password`
- Client: `email: leah@example.com, password: password`

4. You can use the search button to search for a business, location (try `Chicago`), or service (try `Haircut`).

5. Create a new booking by going to a business's profile page and clicking the `Book` button beside a service.
![alt text](booking_as_client.png)

After you create the booking, it will show up as `Pending` until the status is updated by the business owner.
![alt text](pending_booking_screenshot.png)

6. If you are on a business owner page, you can accept or decline an incoming booking.
![alt text](accept_and_decline.png)

7. As a business owner, you can edit your basic business information, business hours, and services from your profile. You can also use the drop-down menu to navigate to your `Bookings`, `Calendar`, `Services`, and `Business Hours` pages to manage your bookings and edit the aspects of your business there.
![alt text](business_profile.png)

## Entity Relationship Diagram
![alt text](book_me_erd.png)

## Troubleshooring

## Contributing
Contributions are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a new branch (`git checkout -b feature-branch`)
3. Commit your changes (`git commit -m 'Add some feature'`)
4. Push to the branch (`git push origin feature-branch`)
5. Open a pull request

## License
Distributed under the MIT License. See `LICENSE` for more information.

## Contact
Your Name - [your email](mailto:youremail@example.com)
Project Link: [https://github.com/yourusername/yourproject](https://github.com/yourusername/yourproject)
