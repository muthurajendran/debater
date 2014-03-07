json.array!(@topics) do |topic|
  json.extract! topic, :id, :question, :enable
  json.url topic_url(topic, format: :json)
end
