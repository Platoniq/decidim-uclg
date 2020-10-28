# frozen_string_literal: true

def current_private_invite_instructions(private_user_to)
  default = Rails.application.secrets.dig(:private_invites, private_user_to.organization.host.to_sym, :default)
  default = "invite_private_user" if default.nil?
  custom = Rails.application.secrets.dig(:private_invites, private_user_to.organization.host.to_sym, private_user_to.manifest.name, private_user_to.slug.to_sym)

  custom || default
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

      @user.invite!(
        form.invited_by,
        invitation_instructions: form.invitation_instructions,
        skip_invitation: skip_invitation
      )
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

      user.invite!(user.invited_by, invitation_instructions: instructions, skip_invitation: skip_invitation)
      broadcast(:ok)
    end
  end
end
