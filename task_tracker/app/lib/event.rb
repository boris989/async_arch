# frozen_string_literal: true

class Event < Dry::Struct
  attribute :event_id, Types::String.default { SecureRandom.uuid }
  attribute :event_name, Types::String
  attribute :event_version, Types::Integer
  attribute :event_time, Types::String.default { Time.current.to_s }
  attribute :producer, Types::String.default('task_tracker_service')
  attribute :data, Types::Hash
end
