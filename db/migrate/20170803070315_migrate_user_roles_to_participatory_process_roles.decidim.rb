# This migration comes from decidim (originally 20170713131308)
# frozen_string_literal: true

class MigrateUserRolesToParticipatoryProcessRoles < ActiveRecord::Migration[5.1]
  def up
    participatory_processes = Decidim::ParticipatoryProcess.includes(:organization).all
    Decidim::User.find_each do |user|
      next if user.roles.empty? || user.roles.include?('admin')

      processes = participatory_processes.select { |process| process.organization == user.organization }
      values = processes.map do |process|
        user.roles.map do |role|
          "(#{user.id}, #{process.id}, '#{role}', NOW(), NOW())"
        end
      end

      execute("
        INSERT INTO decidim_admin_participatory_process_user_roles
        (decidim_user_id, decidim_participatory_process_id, role, created_at, updated_at)
        VALUES #{values.join(', ')}
      ")
    end
    remove_column :decidim_users, :roles
  end
end
