# frozen_string_literal: true

require "rails_helper"

describe "The conference program page", type: :system, perform_enqueued: true do
  let(:organization) { create :organization }
  let!(:conference) { create :conference, slug: "test", organization: organization }
  let!(:component) do
    create(:component, manifest_name: :meetings, participatory_space: conference, id: 999)
  end

  let!(:meeting) { create(:meeting, component: component) }

  before do
    switch_to_host(organization.host)
    visit decidim_conferences.conference_conference_program_path(conference, component)
  end

  describe "the soundcloud widget" do
    it "is rendered" do
      expect(page).to have_selector("#soundcloudEmbed")
    end
  end
end
