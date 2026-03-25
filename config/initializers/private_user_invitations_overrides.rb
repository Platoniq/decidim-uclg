# frozen_string_literal: true

Rails.application.config.to_prepare do
  ###### Debates official user customization
  Decidim::Debates::OfficialAuthorPresenter.class_eval do
    def name
      "#UCLGMeets"
    end

    def avatar_url
      ActionController::Base.helpers.asset_pack_path("media/images/logo-uclg.png")
    end
  end
end
