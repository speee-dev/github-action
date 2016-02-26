# frozen_string_literal: true
class DailyImporter
  include Virtus.model

  attribute :target_date, Date

  def run
    normalize
    PullRequest.search(target_date).each(&:save)
  end

  private

  def normalize
    return if target_date.is_a?(Date)
    self.target_date = Date.yesterday
  end
end
