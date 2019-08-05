class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  MAX_PER_PAGE = 30
  DEFAULT_PER_PAGE = 10

  def self.paginate(args = {})
    page = args[:page] || 1
    per_page = args[:per_page] || self::DEFAULT_PER_PAGE
    per_page = self::MAX_PER_PAGE if per_page > self::MAX_PER_PAGE
    page(page).per(per_page).recent
  end
end
