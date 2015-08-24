class RenameExampleToHelp < ActiveRecord::Migration
  def change
    rename_column :metrics, :example, :help
  end
end
