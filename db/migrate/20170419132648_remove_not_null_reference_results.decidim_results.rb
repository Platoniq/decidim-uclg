# frozen_string_literal: true

# This migration comes from decidim_results (originally 20170410074358)
class RemoveNotNullReferenceResults < ActiveRecord::Migration[5.0]
  def change
    change_column_null :decidim_results_results, :reference, true
  end
end
