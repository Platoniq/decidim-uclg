# frozen_string_literal: true

class AddExtraToDecidimUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :decidim_users, :extra, :jsonb
  end
end
