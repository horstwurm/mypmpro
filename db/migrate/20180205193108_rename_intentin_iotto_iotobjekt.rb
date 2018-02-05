class RenameIntentinIottoIotobjekt < ActiveRecord::Migration[5.0]
  def change
    rename_column :iots, :intent, :frame
  end
end
