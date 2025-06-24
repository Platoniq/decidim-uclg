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
      "/app/views/layouts/decidim/_logo.html.erb" => "9714a2447e07f302c499ff588253a2f2",
      "/app/views/layouts/decidim/_mailer_logo.html.erb" => "f7978aeedda4a905b9775c5cf8c4acc7",
      "/app/views/layouts/decidim/mailer.html.erb" => "4e308c82acd8b1dac405ff71963d8743",
      "/app/commands/decidim/invite_user.rb" => "02eefa14aec8b2cc4c94b9231415932f",
      "/app/commands/decidim/invite_user_again.rb" => "d2cbe35da2285cd9c637a2434124842e"
    }
  }, {
    package: "decidim-admin",
    files: {
      "/app/controllers/decidim/admin/concerns/has_private_users.rb" => "843262c6c1d212b64f67d361ae237510",
      "/app/commands/decidim/admin/create_participatory_space_private_user.rb" => "5c354131b4bcd3deb74780595091c502"
    }
  }, {
    package: "decidim-assemblies",
    files: {
      "/app/controllers/decidim/assemblies/admin/participatory_space_private_users_controller.rb" => "af5800660a90e5391414254b73f475d8"
    }
  }, {
    package: "decidim-conferences",
    files: {
      "/app/views/decidim/conferences/conference_program/show.html.erb" => "e1f0729222b339db3d1fc4b6902ef01a",
      "/app/views/decidim/conferences/conferences/show.html.erb" => "eb94f807d798fe1ed4d1404dd1dfcad9"
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
