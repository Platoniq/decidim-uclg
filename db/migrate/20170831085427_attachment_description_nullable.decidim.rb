# frozen_string_literal: true

# This migration comes from decidim (originally 20170804125402)
# This file has been modified by `decidim upgrade:migrations` task on 2026-03-18 16:04:24 UTC
class AttachmentDescriptionNullable < ActiveRecord::Migration[5.1]
  def change
    change_column :decidim_attachments, :description, :jsonb, null: true
  end
end
