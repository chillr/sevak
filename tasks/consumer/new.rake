require 'highline'

namespace :consumer do

  desc 'Interactively create a new consumer'
  task :new do

    cli = HighLine.new

    consumer_name = cli.ask('Input consumer name(eg. push_alert) :') { |q| q.validate = /\A[a-z]+[a-z_]+[a-z]\z/}
    queue_name    = cli.ask('Input queue name(eg. myqueue)') { |q| q.validate = /\A[a-z]+[a-z.]+[a-z]\z/}

    to_class_name = Proc.new do |name|
      name.split('_').map(&:capitalize).join
    end

text1 = <<-CODE

module Sevak

  class #{to_class_name.call(consumer_name)}Consumer < Consumer

    queue_name "#{queue_name}"

    def run(payload)
      puts "Consumer running"
    end
  end

end

CODE

    if File.exists?("app/consumers/#{consumer_name}_consumer.rb")
      puts "Already exists file: app/consumers/#{consumer_name}_consumer.rb"
      ans = cli.ask('Do you want to overwrite it ? (y/n)') { |q| q.validate = /Y|N|y|n/}
      exit(-1) if ans.downcase == 'n'
    end

    file = File.open("app/consumers/#{consumer_name}_consumer.rb", 'w+')
    file.write(text1)
    file.close

text2 = <<-CODE
namespace :sevak do

  desc "Run the #{consumer_name} worker"
  task :#{consumer_name} do
    autoload(:#{to_class_name.call(consumer_name)}Consumer, './app/consumers/#{consumer_name}_consumer.rb')
    Sevak.config.autoscale = true if ENV['REPLICA']
    consumer = Sevak::#{to_class_name.call(consumer_name)}Consumer.new
    consumer.start
  end
end

CODE

    if File.exists?("lib/tasks/#{consumer_name}.rake")
      puts "Already exists file: lib/tasks/#{consumer_name}.rake"
      ans = cli.ask('Do you want to overwrite it ? (y/n)') { |q| q.validate = /Y|N|y|n/}
      exit(-1) if ans.downcase == 'n'
    end

    file = File.open("lib/tasks/#{consumer_name}.rake", 'w+')
    file.write(text2)
    file.close

  end
end
