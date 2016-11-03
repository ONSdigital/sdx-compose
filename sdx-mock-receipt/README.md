# sdx-mock-receipt

The sdx-mock-receipt service is used within the Office for National Statistics (ONS) for mocking the Survey Data Exchange (SDX) Receipting service.

## Installation

Using virtualenv and pip, create a new environment and install within using:

    $ pip install -r test_requirements.txt

It's also possible to install within a container using docker. From the sdx-mock-receipt directory:

    $ docker build -t sdx-mock-receipt .

## Usage

Start sdx-mock-receipt service using the following command:

    python server.py

If you've built the image under docker, you can start using the following:

    docker run -p 5000:5000 sdx-mock-receipt

sdx-mock-receipt exposes a single endpoint '/reportingunits/{ru_ref}/collectionexercises/{exercise_sid}/receipts' and by default binds to port 5000 on localhost. It returns a xml error response with status 400 (found under templates) to indicate whether the endpoint arguments are valid. If the response is successful, it responds with a 201 status.
