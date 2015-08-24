class AddFeedbackToMetrics < ActiveRecord::Migration
  def change
    add_column :metrics, :feedback, :string
  end
end
