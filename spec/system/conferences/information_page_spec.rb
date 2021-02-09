# frozen_string_literal: true

require "rails_helper"

describe "The conference information page", type: :system, perform_enqueued: true do
  let(:organization) { create :organization }
  let(:slug) { "test-conference" }
  let!(:conference) { create :conference, organization: organization, slug: slug }
  let(:conference_settings) { Rails.application.secrets.dig(:uclg, :conferences).find { |conference| conference[:slug] == slug } }

  let!(:conference_2) { create :conference, organization: organization }

  let(:iframe_src) { page.find("#videoEmbed iframe")[:src] }
  let(:hidden_iframe_src) { page.find("#videoEmbed iframe", visible: false)[:src] }

  context "when visiting the defined conference" do
    before do
      switch_to_host(organization.host)
      visit decidim_conferences.conference_path(conference.id)
    end

    describe "the video modal" do
      it "is rendered" do
        expect(iframe_src).to match(conference_settings[:video_url][:en])
      end

      it "can be closed" do
        within "#videoEmbed" do
          page.find(".close-button").click
          expect(page).not_to have_selector("#videoEmbed")
        end
      end

      context "when changing language" do
        [:es, :fr].each do |locale|
          it "renders video in '#{locale}'" do
            within "#videoEmbed" do
              page.find(".close-button").click
            end
            within_language_menu do
              page.find("li[lang='#{locale}'] a").click
            end
            page.find(".watch-video button").click
            expect(iframe_src).to match(conference_settings[:video_url][locale])
          end
        end
      end

      context "when the page is loaded again" do
        before do
          visit decidim_conferences.conference_path(conference.id)
          within "#videoEmbed" do
            page.find(".close-button").click
          end
          visit decidim_conferences.conference_path(conference.id)
        end

        it "does not open again" do
          expect(page).not_to have_selector("#videoEmbed")
          expect(hidden_iframe_src).not_to match("autoplay")
        end
      end
    end
  end

  context "when visiting another conference" do
    before do
      switch_to_host(organization.host)
      visit decidim_conferences.conference_path(conference_2.id)
    end

    describe "the video modal" do
      it "is not rendered" do
        expect(page).to have_no_selector("#videoEmbed")
      end
    end
  end
end
