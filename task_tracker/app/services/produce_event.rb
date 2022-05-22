class ProduceEvent
  def self.call(event_name:, event_version:, data:, schema:, topic:)
    event = Event.new(
      event_name: event_name,
      event_version: event_version,
      data: data
    )
    result = SchemaRegistry.validate_event(event.to_h, schema, version: event.event_version)

    if result.success?
      WaterDrop::SyncProducer.call(event.to_json, topic: topic)
    else
      raise "Invalid event #{event.to_h}, #{result.failure}"
    end
  end
end