# Current version

    0.4.4

Sevak gem makes it easy to send and receive messages from rabbitmq queues. It is built on top of the bunny gem.
It also supports delayed queuing using [rabbitmq delayed exchange plugin](https://github.com/rabbitmq/rabbitmq-delayed-message-exchange)


Durable option is enabled for all the queues to have persisting queues.  

# Dependencies

* [rabbitmq delayed exchange plugin](https://github.com/rabbitmq/rabbitmq-delayed-message-exchange):

To install this plugin:

  1. Download the latest build for the plugin from [here](http://www.rabbitmq.com/community-plugins.html)
  2. Enable the plugin using command:

    rabbitmq-plugins enable rabbitmq_delayed_message_exchange

# Installation

    gem install sevak

# Configuration

Create a file under `config/initializers` and add following lines to that file:

    Sevak.configure do |f|
        f.host = 'localhost'
        f.port = '5672'
        f.user = 'username'
        f.password = 'password'
        f.prefetch_count = 10
    end

# Usage:

### Publishing to a queue

To publish any message to a queue use the following syntax:

    Sevak::Publisher.publish(*queue_name*, *message*)

If the queue is not present already it will be created automatically.

Example:

    Sevak::Publisher.delayed_publish('sms', message = { name: 'Deepak', msisdn: '9078657543' })

### Publishing to a queue with a delay

To publish any message to a queue with some delay use the following syntax:

    Sevak::Publisher.publish(*queue_name*, *message*, *delay in milliseconds*)

Example:

    Sevak::Publisher.delayed_publish('sms', message = { name: 'Deepak', msisdn: '9078657543' }, 10000)

This will publish the message to an exchange which will route the message to the specified queue with a delay of 10 seconds.

### Receiving messages from the queue
To receive message from this queue and process the message create a consumer file for each queue in your project under `app/consumers`.

    class SmsConsumer < Sevak::Consumer

        queue_name 'sms'

        def run(message)
            *process the message*
        end

        ..
    end

The return status can have three values :ok, :error, :retry.
