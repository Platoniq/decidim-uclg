# UCLG

[![Lint](https://github.com/Platoniq/decidim-uclg/actions/workflows/lint.yml/badge.svg)](https://github.com/Platoniq/decidim-uclg/actions/workflows/lint.yml)
[![Test](https://github.com/Platoniq/decidim-uclg/actions/workflows/test.yml/badge.svg)](https://github.com/Platoniq/decidim-uclg/actions/workflows/test.yml)

Free Open-Source participatory democracy, citizen participation and open government for cities and organizations

This is the open-source repository for UCLG, based on [Decidim](https://github.com/decidim/decidim).

## Setting up the application

You will need to do some steps before having the app working properly once you've deployed it:

- Open a Rails console in the server: `bundle exec rails console`
- Create a System Admin user:

```ruby
user = Decidim::System::Admin.new(email: <email>, password: <password>, password_confirmation: <password>)
user.save!

```

- Visit `<your app url>/system` and login with your system admin credentials
- Create a new organization. Check the locales you want to use for that organization, and select a default locale.
- Set the correct default host for the organization, otherwise the app will not work properly. Note that you need to include any subdomain you might be using.
- Fill the rest of the form and submit it.

You're good to go!
