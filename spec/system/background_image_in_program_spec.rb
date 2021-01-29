# frozen_string_literal: true

require "rails_helper"

describe "The conference program page", type: :system, perform_enqueued: true do
  let(:organization) { create :organization }
  let!(:conference) { create :conference, slug: "test", organization: organization }
  let!(:component) do
    create(:component, manifest_name: :meetings, participatory_space: conference, id: 999)
  end

  let!(:meeting) { create(:meeting, component: component) }

  context "when visiting the defined path" do
    before do
      switch_to_host(organization.host)
      visit decidim_conferences.conference_conference_program_path(conference, component)
    end

    describe "the background" do
      it "has an image" do
        element = page.find("main section:nth-child(3)")
        expect(element.style("background-image")).not_to eq("background-image" => "none")
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
        element = page.find("main section:nth-child(3)")
        expect(element.style("background-image")).to eq("background-image" => "none")
      end
    end
  end
end
