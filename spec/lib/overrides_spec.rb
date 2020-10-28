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
      "/app/views/layouts/decidim/_logo.html.erb" => "eaf30db076df1ceabd7647053df5cff6",
      "/app/views/layouts/decidim/_mailer_logo.html.erb" => "0886c799767b3035a76d596a2c2e914c",
      "/app/views/layouts/decidim/_mini_footer.html.erb" => "a542cf5dcbff8c33f5a5098a06f1ac2b",
      "/app/views/layouts/decidim/mailer.html.erb" => "5bbe335c1dfd02f8448af287328a49dc",
      # classes
      "/app/commands/decidim/invite_user.rb" => "30b3d50ffe162180f2a0ba30a76db745",
      "/app/commands/decidim/invite_user_again.rb" => "a32e2f24d653c81aebc77af128f477d1",
    }
  },{
    package: "decidim-admin",
    files: {
      # classes
      "/app/controllers/decidim/admin/concerns/has_private_users.rb" => "c40d4da1b9b4fa389fdb60a0d0e2e8f7",
      "/app/commands/decidim/admin/create_participatory_space_private_user.rb" => "3218d35c8bbc77abfbbc56ba1d2bf427",
    }
  },{
    package: "decidim-assemblies",
    files: {
      # classes
      "/app/controllers/decidim/assemblies/admin/participatory_space_private_users_controller.rb" => "af5800660a90e5391414254b73f475d8",
    }
  }
]

describe "Overriden files", type: :view do
  checksums.each do |item|
    # rubocop:disable Rails/DynamicFindBy
    spec = ::Gem::Specification.find_by_name(item[:package])
    # rubocop:enable Rails/DynamicFindBy
    item[:files].each do |file, signature|
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
