# frozen_string_literal: true

require "rails_helper"

describe "The conference information page", type: :system, perform_enqueued: true do
  let(:organization) { create :organization }
  let(:slug) { "test-conference" }
  let!(:conference) { create :conference, organization: organization, slug: slug }
  let(:conference_settings) { Rails.application.secrets.dig(:uclg, :conferences).find { |conference| conference[:slug] == slug } }

  let!(:conference_2) { create :conference, organization: organization }

  context "when visiting the defined conference" do
    before do
      switch_to_host(organization.host)
      visit decidim_conferences.conference_path(conference.id)
    end

    describe "the video modal" do
      it "is rendered" do
        expect(page).to have_selector("#videoEmbed")
        expect(page.find("#videoEmbed iframe")[:src]).to match(conference_settings[:video_url])
      end

      it "can be closed" do
        within "#videoEmbed" do
          page.find(".close-button").click
          expect(page).not_to have_selector("#videoEmbed")
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
