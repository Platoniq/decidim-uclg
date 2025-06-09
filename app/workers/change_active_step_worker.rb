# frozen_string_literal: true

require "rake"

Rails.application.load_tasks

class ChangeActiveStepWorker
  include Sidekiq::Worker

  def perform(*_args)
    Rake::Task["decidim_participatory_processes:change_active_step"].invoke
  end
end
