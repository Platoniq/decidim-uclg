# frozen_string_literal: true

def current_private_invite_instructions(space)
  default = Rails.application.secrets.dig(:private_invites, space.organization.host.to_sym, :default)
  default = "invite_private_user" if default.nil?
  custom = Rails.application.secrets.dig(:private_invites, space.organization.host.to_sym, space.manifest.name, space.slug.to_sym)

  return default if custom.nil?

  custom
end

Rails.application.config.to_prepare do
  # Override command for creating invites
  Decidim::Admin::CreateParticipatorySpacePrivateUser.class_eval do
    def invitation_instructions
      current_private_invite_instructions(@private_user_to)
    end
  end

  # Override manual re-sending method
  # TODO: processes
  Decidim::Assemblies::Admin::ParticipatorySpacePrivateUsersController.class_eval do
    before_action on: [:index] do
      instructions = current_private_invite_instructions(current_participatory_space)
      flash.now[:notice] = if instructions == "invite_private_user"
                             "Adding users to this assembly will send standard invitation instructions"
                           elsif instructions.blank?
                             "Adding users to this assembly won't send any invitation email"
                           else
                             "Adding users to this assembly will send specific invitation instructions [#{instructions}]"
                           end
    end

    def resend_invitation
      @private_user = collection.find(params[:id])
      enforce_permission_to :invite, :space_private_user, private_user: @private_user

      instructions = current_private_invite_instructions(current_participatory_space)
      Decidim::InviteUserAgain.call(@private_user.user, instructions) do
        on(:ok) do
          flash[:notice] = I18n.t("users.resend_invitation.success", scope: "decidim.admin")
        end

        on(:invalid) do
          flash[:alert] = I18n.t("users.resend_invitation.error", scope: "decidim.admin")
        end
      end

      redirect_to after_destroy_path
    end
  end

  # Do not send any message if invitation_instructions is false
  Decidim::InviteUser.class_eval do
    def invite_user
      @user = Decidim::User.new(
        name: form.name,
        email: form.email.downcase,
        nickname: Decidim::UserBaseEntity.nicknamize(form.name, organization: form.organization),
        organization: form.organization,
        admin: form.role == "admin",
        roles: form.role == "admin" ? [] : [form.role].compact
      )

      skip_invitation = false
      unless form.invitation_instructions
        Rails.logger.warn "SKIPPED user invitation mail for #{user.email}"
        skip_invitation = true
      end

      @user.invite!(form.invited_by, invitation_instructions: form.invitation_instructions) do |u|
        u.skip_invitation = skip_invitation
      end
    end
  end

  # Do not send any message if invitation_instructions is false
  Decidim::InviteUserAgain.class_eval do
    def call
      skip_invitation = false
      unless instructions
        Rails.logger.warn "SKIPPED user invitation-again mail for #{user.email}"
        skip_invitation = true
      end

      user.invite!(user.invited_by, invitation_instructions: instructions) do |u|
        u.skip_invitation = skip_invitation
      end
      broadcast(:ok)
    end
  end

  ###### Debates official user customization
  Decidim::Debates::OfficialAuthorPresenter.class_eval do
    def name
      "#UCLGMeets"
    end

    def avatar_url
      ActionController::Base.helpers.asset_path("media/images/logo-uclg.png")
    end
  end
end
