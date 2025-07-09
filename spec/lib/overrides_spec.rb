# frozen_string_literal: true

require "rails_helper"

# We make sure that the checksum of the file overriden is the same
# as the expected. If this test fails, it means that the overriden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-core",
    files: {
      "/app/packs/stylesheets/decidim/legacy/email.scss" => "be1d2c978a80cca492954666677cd4bd",
      "/app/views/layouts/decidim/_logo.html.erb" => "fbacc5a8c45d45be0bd4e42fbec40d8f",
      "/app/views/layouts/decidim/_mailer_logo.html.erb" => "8c6978d195e708d7d85ccfe63b710fa8",
      "/app/views/layouts/decidim/mailer.html.erb" => "23a555f9c674d7db4b0ea6582525e2d6",
      "/app/commands/decidim/invite_user.rb" => "d23dd6cb2a2c500d9e56deef26792ffd",
      "/app/commands/decidim/invite_user_again.rb" => "d2cbe35da2285cd9c637a2434124842e"
    }
  }, {
    package: "decidim-admin",
    files: {
      "/app/controllers/decidim/admin/concerns/has_private_users.rb" => "1a0f3f68684f0a0655d156b73bea8cdb",
      "/app/commands/decidim/admin/create_participatory_space_private_user.rb" => "81b2a47da331d70d8f530777b9b11dc2"
    }
  }, {
    package: "decidim-assemblies",
    files: {
      "/app/controllers/decidim/assemblies/admin/participatory_space_private_users_controller.rb" => "964eef145534d80b61e4bfff07708403"
    }
  }, {
    package: "decidim-conferences",
    files: {
      "/app/views/decidim/conferences/conference_program/show.html.erb" => "e1f0729222b339db3d1fc4b6902ef01a",
      "/app/views/decidim/conferences/conferences/show.html.erb" => "f473d522ddc4c5f3352f3fc55cffdd7d",
      "/app/views/decidim/conferences/conferences/_conference_hero.html.erb" => "da4e86d29cf4272356d4bed6130d641f"
    }
  }, {
    package: "decidim-debates",
    files: {
      "/app/presenters/decidim/debates/official_author_presenter.rb" => "f47ad586da31ff30ad853e170c3b773f"
    }
  }, {
    package: "decidim-direct_verifications",
    files: {
      # The only change for controllers is the full namespace for the parent class as it didn't resolved it well when it
      # was just ApplicationController
      "/app/controllers/decidim/direct_verifications/verification/admin/authorizations_controller.rb" => "5b713aa72da2ba5e4f0fefa840816004",
      "/app/controllers/decidim/direct_verifications/verification/admin/direct_verifications_controller.rb" => "dfe29d5353030989c07866d37b794157",
      "/app/controllers/decidim/direct_verifications/verification/admin/imports_controller.rb" => "43852a21a6aca14404c2959bb70bdb19",
      "/app/controllers/decidim/direct_verifications/verification/admin/stats_controller.rb" => "a0c4ae48b1372ea5d37aae0112c9c826",
      "/app/controllers/decidim/direct_verifications/verification/admin/user_authorizations_controller.rb" => "705d2ef9a0c33ad68899b28c4b1dc42d"
    }
  }
]

describe "Overridden files", type: :view do
  checksums.each do |item|
    spec = Gem::Specification.find_by_name(item[:package])

    item[:files].each do |file, signature|
      next unless spec

      it "#{spec.gem_dir}#{file} matches checksum" do
        expect(md5("#{spec.gem_dir}#{file}")).to eq(signature)
      end
    end
  end

  private

  def md5(file)
    Digest::MD5.hexdigest(File.read(file))
  end
end
