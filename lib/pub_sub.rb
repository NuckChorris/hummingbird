class PubSub
  PING_TIME = 15
  HELLO = {event: 'hello', data: ''}

  def self.call(env)
    if Faye::WebSocket.websocket?(env) # WebSocket
      faye = Faye::WebSocket.new(env, nil, ping: PING_TIME, retry: 30)
    elsif Faye::EventSource.eventsource?(env) # EventSource
      faye = Faye::EventSource.new(env, ping: PING_TIME, retry: 30)
    else
      return [400, {}, [{
        error: 'Bad Request',
        message: 'Not a WebSocket or EventSource connection'
      }.to_json]]
    end

    faye.send(*serialize(faye, HELLO))

    $redis.subscribe('system') do |on|
      on.message do |chan, msg|
        $stderr.puts 'Sending via %s' % [faye.class.name]
        msg = ActiveSupport::JSON.decode(msg)
        faye.send(*serialize(faye, msg))
      end
    end
    faye.on(:close) do
      $stderr.puts 'Closing thread'
    end

    faye.rack_response
  end

  def self.publish(channel, event, data)
    $redis.publish(channel, {
      event: event,
      data: data
    }.to_json)
  end

  def self.serialize(transport, obj)
    case transport
    when Faye::WebSocket
      [obj.to_json]
    when Faye::EventSource
      [obj['data'].to_json, { event: obj['event'] }]
    end
  end
end
