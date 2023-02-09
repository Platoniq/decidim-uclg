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
      "/app/views/layouts/decidim/_mailer_logo.html.erb" => "7fe70aeb7eb6241107d37b12bd8b5876",
      "/app/views/layouts/decidim/_mini_footer.html.erb" => "55a9ca723b65b8d9eadb714818a89bb3",
      "/app/views/layouts/decidim/mailer.html.erb" => "0c7804de08649c8d3c55c117005e51c9",
      "/app/assets/javascripts/decidim/floating_help.js.es6" => "b25ba694db0fd880442b4310d9ece55c",
      # classes
      "/app/commands/decidim/invite_user.rb" => "30b3d50ffe162180f2a0ba30a76db745",
      "/app/commands/decidim/invite_user_again.rb" => "19f2655763d77ba0804ceef7fc97adfa"
    }
  }, {
    package: "decidim-admin",
    files: {
      # classes
      "/app/controllers/decidim/admin/concerns/has_private_users.rb" => "c40d4da1b9b4fa389fdb60a0d0e2e8f7",
      "/app/commands/decidim/admin/create_participatory_space_private_user.rb" => "b380a8e10e9f54aff7e2669f128b261a"
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
      "/app/views/decidim/conferences/conferences/show.html.erb" => "2b158a066257f7a8d0b30cb6987dd45c"
    }
  }, {
    package: "decidim-debates",
    files: {
      # views
      "/app/views/decidim/debates/debates/index.html.erb" => "02ab9ec14f9c158f5e30a589e285f8d2",
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
