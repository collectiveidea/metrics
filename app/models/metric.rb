class Metric < ActiveRecord::Base
  validates :name, :pattern, presence: true
  validate :pattern_must_be_valid

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
