# frozen_string_literal: true

# This migration comes from decidim (originally 20170808080905)
# This file has been modified by `decidim upgrade:migrations` task on 2026-08-20 08:52:22 UTC
class AddAnnouncementToParticipatoryProcesses < ActiveRecord::Migration[5.1]
  def change
    add_column :decidim_participatory_processes, :announcement, :jsonb
  end
end
