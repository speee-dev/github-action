# frozen_string_literal: true
module EsStorable
  extend ActiveSupport::Concern

  @es_client = Elasticsearch::Client.new host: Settings.elasticsearch.host

  def es_client
    EsStorable.es_client
  end

  def self.es_client
    @es_client
  end
end
