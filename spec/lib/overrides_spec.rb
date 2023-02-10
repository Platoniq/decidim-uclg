# frozen_string_literal: true

require "rails_helper"

# We make sure that the checksum of the file overriden is the same
# as the expected. If this test fails, it means that the overriden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-core",
    files: {
      # layouts
      "/app/views/layouts/decidim/_logo.html.erb" => "ab01dd1df9ce62cbd62f640a3b5018b2",
      "/app/views/layouts/decidim/_mailer_logo.html.erb" => "7fe70aeb7eb6241107d37b12bd8b5876",
      "/app/views/layouts/decidim/_mini_footer.html.erb" => "5a842f3e880f24f49789ee2f72d96f60",
      "/app/views/layouts/decidim/mailer.html.erb" => "0c7804de08649c8d3c55c117005e51c9",
      "/app/packs/src/decidim/floating_help.js" => "b25ba694db0fd880442b4310d9ece55c",
      # classes
      "/app/commands/decidim/invite_user.rb" => "30b3d50ffe162180f2a0ba30a76db745",
      "/app/commands/decidim/invite_user_again.rb" => "19f2655763d77ba0804ceef7fc97adfa"
    }
  }, {
    package: "decidim-admin",
    files: {
      # classes
      "/app/controllers/decidim/admin/concerns/has_private_users.rb" => "afc68907e570f396b80e6d208413a7ac",
      "/app/commands/decidim/admin/create_participatory_space_private_user.rb" => "0a177e0bc25c0110a19bb605a862d56d"
    }
  }, {
    package: "decidim-assemblies",
    files: {
      # classes
      "/app/controllers/decidim/assemblies/admin/participatory_space_private_users_controller.rb" => "af5800660a90e5391414254b73f475d8"
    }
  }, {
    package: "decidim-conferences",
    files: {
      # views
      "/app/views/decidim/conferences/conference_program/show.html.erb" => "e4d32ccc41adea7d9689b9021ef83694",
      "/app/views/decidim/conferences/conferences/show.html.erb" => "2a39789fdca15b55f9a8eee8d6af9184"
    }
  }, {
    package: "decidim-debates",
    files: {
      # views
      "/app/views/decidim/debates/debates/index.html.erb" => "4bcbeae81fd9fea19d5fff97d1a025c1",
      "/app/presenters/decidim/debates/official_author_presenter.rb" => "f47ad586da31ff30ad853e170c3b773f"
      # classes
    }
  }, {
    package: "decidim-direct_verifications",
    files: {
      # The only change for controllers is the full namespace for the parent class as it didn't resolved it well when it
      # was just ApplicationController
      "/app/controllers/decidim/direct_verifications/verification/admin/authorizations_controller.rb" => "ec24f7eb75ad7ab298ef13a956873cf6",
      "/app/controllers/decidim/direct_verifications/verification/admin/direct_verifications_controller.rb" => "4f9cef25f72bb5ce88480850bd3f162a",
      "/app/controllers/decidim/direct_verifications/verification/admin/imports_controller.rb" => "477a63f3c749de204ccdc0987cd6b20d",
      "/app/controllers/decidim/direct_verifications/verification/admin/stats_controller.rb" => "a0c4ae48b1372ea5d37aae0112c9c826",
      "/app/controllers/decidim/direct_verifications/verification/admin/user_authorizations_controller.rb" => "c0f3387a8b76ecdf238e12e6c03daf3e"
    }
  }
]

describe "Overriden files", type: :view do
  # rubocop:disable Rails/DynamicFindBy
  checksums.each do |item|
    spec = ::Gem::Specification.find_by_name(item[:package])

    item[:files].each do |file, signature|
      it "#{spec.gem_dir}#{file} matches checksum" do
        expect(md5("#{spec.gem_dir}#{file}")).to eq(signature)
      end
    end
  end
  # rubocop:enable Rails/DynamicFindBy

  private

  def md5(file)
    Digest::MD5.hexdigest(File.read(file))
  end
end
