# frozen_string_literal: true
desc 'create index for github_action'
task :create_index do
  client = EsStorable.es_client
  unless client.indices.exists? index: :github_action
    client.indices.create index: :github_action
  end
  client.indices.put_mapping(
    index: :github_action,
    type: :pull_request,
    body: {
      pull_request: {
        properties: {
          created_at: {
            type: :date,
          },
          author: {
            type: :string,
            index: :not_analyzed,
          },
        },
      },
    })
end
