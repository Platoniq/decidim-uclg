# frozen_string_literal: true

require "rails_helper"

describe "The conference program page", type: :system, perform_enqueued: true do
  let(:organization) { create :organization }
  let(:slug) { "test-conference" }
  let!(:conference) { create :conference, slug: slug, organization: organization }
  let(:conference_settings) { Rails.application.secrets.dig(:uclg, :conferences).find { |conference| conference[:slug] == slug } }

  let!(:component) do
    create(:component, manifest_name: :meetings, participatory_space: conference)
  end

  let!(:meeting) { create(:meeting, component: component) }

  context "when visiting the defined conference" do
    before do
      switch_to_host(organization.host)
      visit decidim_conferences.conference_conference_program_path(conference, component)
    end

    describe "the background" do
      it "has an image" do
        element = page.find("main .wrapper")
        expect(element.style("background-image")["background-image"]).to match(conference_settings[:page_background].gsub(".png", ""))
      end
    end

    describe "the soundcloud widget" do
      it "is rendered" do
        expect(page).to have_selector("#soundcloudEmbed")
        expect(page.find("#soundcloudEmbed")[:src]).to eq(conference_settings[:soundcloud_url])
      end
    end
  end

  context "when visiting another conference" do
    let!(:conference_2) { create :conference, organization: organization }
    let!(:component_2) do
      create(:component, manifest_name: :meetings, participatory_space: conference_2)
    end

    let!(:meeting_2) { create(:meeting, component: component_2) }

    before do
      switch_to_host(organization.host)
      visit decidim_conferences.conference_conference_program_path(conference_2, component_2)
    end

    describe "the background" do
      it "has no image" do
        element = page.find("main .wrapper")
        expect(element.style("background-image")).to eq("background-image" => "none")
      end
    end

    describe "the soundcloud widget" do
      it "is not rendered" do
        expect(page).to have_no_selector("#soundcloudEmbed")
      end
    end
  end
end
