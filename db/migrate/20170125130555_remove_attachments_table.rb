# frozen_string_literal: true

class RemoveAttachmentsTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :attachments
  end
end
