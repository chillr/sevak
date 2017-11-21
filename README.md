Sevak gem provides makes it easy to send and receive messages from rabbitmq queues. It is buit on top of the bunny gem.


Usage:

Install
    
    gem install sevak

Congigure

    Sevak.configure do |f|
        f.host = 'localhost'
        f.port = '5672'
        f.user = 'username'
        f.password = 'password'
        f.prefetch_count = 10
    end

In your code to publish some message to a queue 'sms'.

    
    Sevak::Publisher.publish('sms', message = { name: 'Deepak', msisdn: '9078657543' })

If the queue is not present already it will be created automatically.


To receive message from this queue and process the message a create a consumer.


    class SmsConsumer < Sevak::Consumer
        
        queue_name 'sms'
        
        def run(message)
            status = process(message)
            status
        end
        
        ..
    end

The return status can have three values :ok, :error, :retry.

Publishing to the queue

    Publisher.publish('in.chillr.email', { name: 'Deepak Kumar', message: 'welcome', email: 'deepak@chillr.in' }) 