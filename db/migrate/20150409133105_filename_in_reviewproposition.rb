class FilenameInReviewproposition < ActiveRecord::Migration
  def change
    add_column :reviewpropositions, :file_name, :string
  end
end
