# frozen_string_literal: true

# This migration comes from decidim (originally 20170207093048)
# This file has been modified by `decidim upgrade:migrations` task on 2026-08-20 08:52:20 UTC
class AddOrganizationLogoAndUrl < ActiveRecord::Migration[5.0]
  def change
    add_column :decidim_organizations, :official_img_header, :string
    add_column :decidim_organizations, :official_img_footer, :string
    add_column :decidim_organizations, :official_url, :string
  end
end
