class RemoveInitiativesTables < ActiveRecord::Migration[5.2]
  def change
    drop_table :decidim_initiatives, if_exists: true
    drop_table :decidim_initiatives_committee_members, if_exists: true
    drop_table :decidim_initiatives_type_scopes, if_exists: true
    drop_table :decidim_initiatives_types, if_exists: true
    drop_table :decidim_initiatives_votes, if_exists: true
  end
end
