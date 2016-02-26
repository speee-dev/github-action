# frozen_string_literal: true
class PullRequest
  include Virtus.model
  include EsStorable

  attribute :id,         Integer
  attribute :html_url,   String
  attribute :title,      String
  attribute :author,     String
  attribute :created_at, Time

  def save
    es_client.index(
      index: :github_action,
      type:  :pull_request,
      id:    id,
      body:  attributes)
  end

  def self.search(target_date)
    query = [
      'type:pr',
      "user:#{Settings.github.repository_owner}",
      "created:#{target_date.to_time.iso8601}..#{(target_date + 1).to_time.iso8601}",
    ].join(' ')

    api_res = Octokit.client.search_issues(
      query,
      sort: :created,
      order: :asc)

    api_res.items.map do |item|
      PullRequest.new(
        id: item.id,
        html_url: item.html_url,
        title: item.title,
        author: item.user.login,
        created_at: item.created_at.in_time_zone('Tokyo'))
    end
  end
end
