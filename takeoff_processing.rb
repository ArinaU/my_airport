
#!/usr/bin/env ruby
require 'bunny'

class TakeoffServer
  def initialize
    @connection = Bunny.new
    @connection.start
    @channel = @connection.create_channel
  end

  def start(queue_name)
    @queue = channel.queue(queue_name)
    @exchange = channel.default_exchange
    subscribe_to_queue
  end

  def stop
    channel.close
    connection.close
  end

  def loop_forever
    loop { sleep 5 }
  end

  private

  attr_reader :channel, :exchange, :queue, :connection

  def subscribe_to_queue
    queue.subscribe do |_delivery_info, properties, payload|
      result = processing(payload)
      p result
      exchange.publish(
          result,
          routing_key: properties.reply_to,
          correlation_id: properties.correlation_id
      )
    end
  end

  def processing(arg)
    sleep Random.rand(10..15)
    "took off"
  end

end

begin
  server = TakeoffServer.new

  server.start('airport_queue')
  server.loop_forever
rescue Interrupt => _
  server.stop
end
