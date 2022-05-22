class ValidateEvent
  def self.call(event:, schema:)
    result = SchemaRegistry.validate_event(event.to_h, schema, version: event.event_version)
    raise "Invalid event #{event.to_h}, #{result.failure}" if result.failure?
  end
end