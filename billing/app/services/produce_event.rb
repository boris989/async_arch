class ProduceEvent
  def self.call(event_name:, event_version:, data:, schema:, topic:)
    event = Event.new(
      event_name: event_name,
      event_version: event_version,
      data: data
    )

    ValidateEvent.call(event: event, schema: schema)

    WaterDrop::SyncProducer.call(event.to_json, topic: topic)

  end
end