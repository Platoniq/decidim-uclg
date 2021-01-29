# frozen_string_literal: true

require "rails_helper"

describe "The conference information page", type: :system, perform_enqueued: true do
  let(:organization) { create :organization }
  let!(:conference) { create :conference, organization: organization }

  before do
    switch_to_host(organization.host)
    visit decidim_conferences.conference_path(conference.id)
  end

  describe "the video modal" do
    it "is rendered" do
      expect(page).to have_selector("#videoEmbed")
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
