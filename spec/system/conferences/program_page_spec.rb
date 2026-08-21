# frozen_string_literal: true

require "rails_helper"

describe "The conference program page", :perform_enqueued do
  let(:organization) { create(:organization, available_locales: %w(en es fr ca)) }
  let(:conference_settings) { Decidim::Uclg::SPECIAL_CONFERENCES.find { |conference| conference[:slug] == slug } }
  let!(:component) do
    create(:component, manifest_name: :meetings, participatory_space: conference)
  end
  let!(:meeting) { create(:meeting, :published, component:) }
  let(:slug) { "test-conference" }
  let!(:conference) { create(:conference, slug:, organization:) }

  before do
    stub_const("Decidim::Uclg::SPECIAL_CONFERENCES", [
                 {
                   slug: "test-conference",
                   page_background: "media/images/Water_Mark.png",
                   soundcloud_url: "https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/playlists/1201873432&color=%23ff0000&hide_related=true&show_comments=false&show_user=false&show_reposts=false&show_teaser=true&visual=true",
                   video_url: {
                     en: "https://www.youtube.com/embed/kpzgUq5BDnY",
                     es: "https://www.youtube.com/embed/byV5O_pAK8c",
                     fr: "https://www.youtube.com/embed/8O1DoHX4c-8"
                   }
                 }
               ])
  end

  context "when visiting the defined conference" do
    before do
      switch_to_host(organization.host)
      visit decidim_conferences.conference_conference_program_path(conference, component)
      page.execute_script("$('#dc-modal-accept').click()")
    end

    describe "the background" do
      it "has an image" do
        element = page.find("main")
        expect(element.style("background-image")["background-image"]).to match(conference_settings[:page_background].gsub(".png", ""))
      end
    end

    describe "the soundcloud widget" do
      it "is rendered" do
        expect(page).to have_css("#soundcloudEmbed")
        expect(page.find_by_id("soundcloudEmbed")[:src]).to eq(conference_settings[:soundcloud_url])
      end

      it "has a link to go to playlist" do
        expect(page).to have_link "Go to playlist", href: "#soundcloudEmbed"
      end
    end
  end

  context "when visiting another conference" do
    # rubocop:disable Naming/VariableNumber
    let!(:conference_2) { create(:conference, organization:) }
    let!(:component_2) do
      create(:component, manifest_name: :meetings, participatory_space: conference_2)
    end

    let!(:meeting_2) { create(:meeting, :published, component: component_2) }
    # rubocop:enable Naming/VariableNumber

    before do
      switch_to_host(organization.host)
      visit decidim_conferences.conference_conference_program_path(conference_2, component_2)
      page.execute_script("$('#dc-modal-accept').click()")
    end

    describe "the background" do
      it "has no image" do
        element = page.find("main")
        expect(element.style("background-image")).to eq("background-image" => "none")
      end
    end

    describe "the soundcloud widget" do
      it "is not rendered" do
        expect(page).to have_no_selector("#soundcloudEmbed")
      end

      it "has no link to go to playlist" do
        expect(page).to have_no_link "Go to playlist"
      end
    end
  end
end
