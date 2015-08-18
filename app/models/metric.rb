class Metric < ActiveRecord::Base
  has_many :data_points, inverse_of: :metric, dependent: :delete_all

  validates :name, :pattern, presence: true
  validate :pattern_must_be_valid

  delegate :=~, to: :regexp

  def regexp
    Regexp.new(pattern)
  end

  private

  def pattern_must_be_valid
    regexp
  rescue RegexpError
    errors.add(:pattern)
  end
end
