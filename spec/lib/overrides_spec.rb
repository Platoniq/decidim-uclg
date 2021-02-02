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
      "/app/views/layouts/decidim/_logo.html.erb" => "2713715db652c8107f1fe5f2c4d618b6",
      "/app/views/layouts/decidim/_mailer_logo.html.erb" => "8abb593b786423070101ded4ea8140b4",
      "/app/views/layouts/decidim/_mini_footer.html.erb" => "55a9ca723b65b8d9eadb714818a89bb3",
      "/app/views/layouts/decidim/mailer.html.erb" => "5bbe335c1dfd02f8448af287328a49dc",
      "/app/assets/javascripts/decidim/floating_help.js.es6" => "b25ba694db0fd880442b4310d9ece55c",
      # classes
      "/app/commands/decidim/invite_user.rb" => "30b3d50ffe162180f2a0ba30a76db745", # TODO: review
      "/app/commands/decidim/invite_user_again.rb" => "a32e2f24d653c81aebc77af128f477d1" # TODO: review
    }
  }, {
    package: "decidim-admin",
    files: {
      # classes
      "/app/controllers/decidim/admin/concerns/has_private_users.rb" => "c40d4da1b9b4fa389fdb60a0d0e2e8f7",
      "/app/commands/decidim/admin/create_participatory_space_private_user.rb" => "3218d35c8bbc77abfbbc56ba1d2bf427"
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
      "/app/views/decidim/conferences/conferences/show.html.erb" => "6f82c0756e52ccbdd3fc82e909f1520b" # TODO: review
    }
  }, {
    package: "decidim-debates",
    files: {
      # views
      "/app/views/decidim/debates/debates/index.html.erb" => "00f61a3f8757ebe89f922378a92c556c", # TODO: review
      "/app/presenters/decidim/debates/official_author_presenter.rb" => "f47ad586da31ff30ad853e170c3b773f"
      # classes
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
