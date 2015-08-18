class DataPoint < ActiveRecord::Base
  belongs_to :metric, inverse_of: :data_points

  store_accessor :data, :user

  validates :metric, presence: true, strict: true
  validates :number, :user, presence: true
  validates :number, numericality: true
end
