# frozen_string_literal: true

base_path = File.expand_path("..", __dir__)

Decidim::Webpacker.register_entrypoints(
  uclg_email: "#{base_path}/app/packs/entrypoints/uclg_email.js"
)
