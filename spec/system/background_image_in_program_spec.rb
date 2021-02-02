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

  context "when visiting the defined path" do
    before do
      switch_to_host(organization.host)
      visit decidim_conferences.conference_conference_program_path(conference, component)
    end

    describe "the background" do
      it "has an image" do
        element = page.find("main .wrapper")
        expect(element.style("background-image")["background-image"]).to match(conference_settings[:program_page_background])
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
  end
end
