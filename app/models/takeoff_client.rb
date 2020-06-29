

require "bunny"
require 'thread'

class TakeoffClient
  attr_accessor :call_id, :response, :lock, :condition, :connection,
                :channel, :server_queue_name, :reply_queue, :exchange

  def initialize
    @connection = Bunny.new(automatically_recover: false)
    @connection.start
    @channel = connection.create_channel
    @exchange = channel.default_exchange
    @server_queue_name = 'airport_queue'

    setup_reply_queue
  end

  def call(plane)
    @call_id = generate_uuid
    p " [x] Requesting take off for plane (#{plane.name})"
    exchange.publish(plane.name,
                     routing_key: server_queue_name,
                     correlation_id: call_id,
                     reply_to: reply_queue.name)

    lock.synchronize { condition.wait(lock) }
    p " [.] #{plane.name} #{response}"
    plane.update(status: response)
    response
  end

  def stop
    channel.close
    connection.close
  end

  private

  def setup_reply_queue
    @lock = Mutex.new
    @condition = ConditionVariable.new
    that = self
    @reply_queue = channel.queue('', exclusive: true)

    reply_queue.subscribe do |_delivery_info, properties, payload|
      if properties[:correlation_id] == that.call_id
        that.response = payload

        # sends the signal to continue the execution of #call
        that.lock.synchronize { that.condition.signal }
      end
    end
  end

  def generate_uuid
    # naive but good enough for the task
    "#{rand}#{rand}#{rand}"
  end
end

