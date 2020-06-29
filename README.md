# README

This is a test airport project with the following technical task:

There is an airport with one runway. The controller is provided with an interface that allows you to send the plane to take off.
The interface allows you to send several planes to take off simultaneously. The take-off itself takes 10+ seconds.
The interface displays the current status of the aircraft (departed, awaits departure (if several have been sent for takeoff), in the hangar), as well as the history of the status change.
Requirements:
- front-end update in real time;
- a separate microservice is engaged in take-off, which counts a random number of seconds and returns a signal that the plane took off
Wishes:
- use NoSQL database for storage.

## Getting started

You need to have installed ruby v2.7.0, rails v6.0.3, MongoDB (mongoid 7.1.2), RabbitMQ (bunny 2.15.0).

After cloning the repository use
```
bundle install
```
 commands in console.

If you want to run a server, use:

```
rails s
```

To run microservice takeoff_processing.rb, run in another terminal:

```
ruby takeoff_processing.rb

```
