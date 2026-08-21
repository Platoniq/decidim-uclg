# frozen_string_literal: true

require "rails_helper"

describe "The conference information page", :perform_enqueued do
  let(:organization) { create(:organization, available_locales: %w(en es fr ca)) }
  let(:conference_settings) { Decidim::Uclg::SPECIAL_CONFERENCES.find { |conference| conference[:slug] == slug } }
  let!(:other_conference) { create(:conference, organization:) }
  let(:slug) { "test-conference" }
  let!(:conference) { create(:conference, organization:, slug:) }

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
      visit decidim.root_path
      click_on "Cookie settings"
      click_on "Accept all"
      visit decidim_conferences.conference_path(conference.id)
    end

    describe "the video modal" do
      it "is rendered" do
        expect(page.find("#conference-video-modal iframe", visible: :all)[:src]).to match(conference_settings[:video_url][:en])
      end

      it "can be closed" do
        page.find("#conference-video-modal button[data-dialog-close='conference-video-modal']", visible: :all).click
        expect(page).to have_css("#conference-video-modal", visible: :hidden)
      end

      context "when changing language" do
        [:es, :fr].each do |locale|
          it "renders video in '#{locale}'" do
            page.find("#conference-video-modal button[data-dialog-close='conference-video-modal']", visible: :all).click
            within_language_menu do
              page.find("li a[lang='#{locale}']").click
            end
            click_on I18n.t("uclg.video_modal.show_video", locale:)
            expect(page.find("#conference-video-modal iframe", visible: :all)[:src]).to match(conference_settings[:video_url][locale])
          end
        end
      end

      context "when the page is loaded again" do
        before do
          visit decidim_conferences.conference_path(conference.id)
          page.find("#conference-video-modal button[data-dialog-close='conference-video-modal']", visible: :all).click
          visit decidim_conferences.conference_path(conference.id)
        end

        it "does not open again" do
          expect(page).to have_no_css("#conference-video-modal")
          expect(page.find("#conference-video-modal iframe", visible: false)[:src]).not_to match("autoplay")
        end
      end
    end
  end

  context "when visiting another conference" do
    before do
      switch_to_host(organization.host)
      visit decidim_conferences.conference_path(other_conference.id)
    end

    describe "the video modal" do
      it "is not rendered" do
        expect(page).to have_no_selector("#conference-video-modal")
      end
    end
  end
end
