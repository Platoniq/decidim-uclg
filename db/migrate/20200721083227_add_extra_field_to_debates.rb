
# This field is not in Decidim but appeart in Barcelona Organizations, we need it
# here to be able to copy the data (it may be removed in the future)
class AddExtraFieldToDebates < ActiveRecord::Migration[5.2]
  def change
  	add_column :decidim_debates_debates, :extra, :jsonb
  end
end
