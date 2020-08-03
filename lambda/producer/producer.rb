require 'base64'
require 'aws-sdk-sqs'
require_relative 'message_pb'

module Producer
  class << self
    def call(event:, context:)
      message = generate_message

      sqs.send_message(
        queue_url: queue_url,
        message_body: serialize(message)
      )

      puts "sent message: #{message.inspect}"
    end

    private

    def sqs
      @sqs ||= Aws::SQS::Client.new(region: 'eu-west-1')
    end

    def queue_url
      ENV['QUEUE_URL']
    end

    def generate_message
      Message.new(
        name: "message #{rand(1..1000)}",
        priority: Message::Priority::HIGH,
        tags: [
          Tag.new(id: rand(1000..10_000), name: 'alpha'),
          Tag.new(id: rand(1000..10_000), name: 'bravo'),
          Tag.new(id: rand(1000..10_000), name: 'charlie'),
          Tag.new(id: rand(1000..10_000), name: 'delta'),
          Tag.new(id: rand(1000..10_000), name: 'echo'),
          Tag.new(id: rand(1000..10_000), name: 'foxtrot'),
          Tag.new(id: rand(1000..10_000), name: 'golf'),
          Tag.new(id: rand(1000..10_000), name: 'hotel'),
          Tag.new(id: rand(1000..10_000), name: 'india'),
        ]
      )
    end

    def serialize(message)
      Base64.encode64(Message.encode(message))
    end
  end
end
