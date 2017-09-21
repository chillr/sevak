# ChillrSevak

 Chillr sevak is a gem built to interface with rabbitmq message brocker. The gem has a generator to
 
 create rabbitmq workers, these workers are run to perform specific tasks such as sending SMS, Push 
 
 notification etc.
 
 ## Creating a new consumer
 
    $ rake consumer:new
   
  The above command will interactively lead you to create a new consumer. You will have to input 
  the consumer name followed by a queue name to create the consumer.
  
  Queue name format: We are using dot separated lowercase strings as queue names. 
  
  eg: in.chillr.push.default
  
  The newly created consumer will be places in the folder **lib/chillr_sevak/consumers**

  A rake task will be created to run the consumer which can be listed by running.
  
    $ rake -T

## Editing the consumer
 
The generated code for the consumer will be as below.

    module ChillrSevak
    
      class PushConsumer < Consumer
    
        queue_name "in.chillr.push.default"
    
        def run(payload)
          puts "Consumer running"
          ## Your code goes here
        end
      end
    
    end

The working logic of the consumer has to be written inside the run method of the consumer.

## Running the consumer

Once the consumer and the consumer rake task added you will be able to run the rake task to run the consumer.

Now whenever data available in the corresponding queue rabbitmq will forward the data to the consumer 
and the consumer will run with the data provided.

    # example
    $ rake sevak:push

# Running tests

    $ rake test

or

    $ guard