# decidim-uclg — gem overrides

_Generated 2026-08-20. Currently on Decidim **0.31.4**._

This app patches files that live inside the decidim gems. `spec/lib/overrides_spec.rb` stores an MD5 of each upstream original, so the suite fails the moment upstream changes one — that is the signal that a local copy has drifted from the version it was forked from.

**18 guarded file(s).**

## Ruby classes (11)

Copied or patched via an `*Override` concern. Needs a real diff of upstream old-vs-new and the customisation re-applied.

| package | file | recorded checksum |
|---|---|---|
| `decidim-core` | `/app/commands/decidim/invite_user.rb` | `d23dd6cb…` |
| `decidim-core` | `/app/commands/decidim/invite_user_again.rb` | `d2cbe35d…` |
| `decidim-admin` | `/app/controllers/decidim/admin/concerns/has_private_users.rb` | `1a0f3f68…` |
| `decidim-admin` | `/app/commands/decidim/admin/create_participatory_space_private_user.rb` | `81b2a47d…` |
| `decidim-assemblies` | `/app/controllers/decidim/assemblies/admin/participatory_space_private_users_controller.rb` | `964eef14…` |
| `decidim-debates` | `/app/presenters/decidim/debates/official_author_presenter.rb` | `f47ad586…` |
| `decidim-direct_verifications` | `/app/controllers/decidim/direct_verifications/verification/admin/authorizations_controller.rb` | `5b713aa7…` |
| `decidim-direct_verifications` | `/app/controllers/decidim/direct_verifications/verification/admin/direct_verifications_controller.rb` | `dfe29d53…` |
| `decidim-direct_verifications` | `/app/controllers/decidim/direct_verifications/verification/admin/imports_controller.rb` | `43852a21…` |
| `decidim-direct_verifications` | `/app/controllers/decidim/direct_verifications/verification/admin/stats_controller.rb` | `a0c4ae48…` |
| `decidim-direct_verifications` | `/app/controllers/decidim/direct_verifications/verification/admin/user_authorizations_controller.rb` | `705d2ef9…` |

## Views (6)

Full copies of gem templates. Re-copy the 0.31 version and re-apply the local change.

| package | file | recorded checksum |
|---|---|---|
| `decidim-core` | `/app/views/layouts/decidim/_logo.html.erb` | `fbacc5a8…` |
| `decidim-core` | `/app/views/layouts/decidim/_mailer_logo.html.erb` | `8c6978d1…` |
| `decidim-core` | `/app/views/layouts/decidim/mailer.html.erb` | `23a555f9…` |
| `decidim-conferences` | `/app/views/decidim/conferences/conference_program/show.html.erb` | `e1f07292…` |
| `decidim-conferences` | `/app/views/decidim/conferences/conferences/show.html.erb` | `f473d522…` |
| `decidim-conferences` | `/app/views/decidim/conferences/conferences/_conference_hero.html.erb` | `da4e86d2…` |

## Assets (1)

Stylesheets/JS copied from the gem.

| package | file | recorded checksum |
|---|---|---|
| `decidim-core` | `/app/packs/stylesheets/decidim/legacy/email.scss` | `be1d2c97…` |

## For the 0.31 upgrade

Every guarded file has to be checked against 0.31. Three outcomes:

1. **Upstream unchanged** — only the checksum needs re-recording.
2. **Upstream renamed** — update the path in the spec as well (0.31 renames Answer→Response across forms/surveys).
3. **Upstream changed** — diff 0.30.x→0.31.4 and re-apply the local customisation.

Compare with:

```
gh api repos/decidim/decidim/contents/<package><file>?ref=v0.30.9 -q .sha
gh api repos/decidim/decidim/contents/<package><file>?ref=v0.31.4 -q .sha
```

Same sha = category 1. 404 on the 0.31 side = category 2.

Conventions worth following (from [decidim-barcelona](https://github.com/AjuntamentdeBarcelona/decidim-barcelona) `.agent/skills/decidim-overrides/SKILL.md`):

- `.include` when the concern **adds** methods, `.prepend` when it **replaces** them, so `super` still reaches upstream.
- decidim_awesome applies Deface overrides by virtual path, so they compose on top of app-level view copies — if a copied view renders differently than it reads, check for a Deface override before hunting a bug.

