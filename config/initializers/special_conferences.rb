# frozen_string_literal: true

module Decidim
  module Uclg
    SPECIAL_CONFERENCES = [
      {
        slug: "AnnualRetreat2021",
        page_background: "media/images/Water_Mark.png",
        soundcloud_url: "https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/playlists/1201873432&color=%23ff0000&hide_related=true&show_comments=false&show_user=false&show_reposts=false&show_teaser=true&visual=true",
        video_url: {
          en: "https://www.youtube.com/embed/kpzgUq5BDnY",
          es: "https://www.youtube.com/embed/byV5O_pAK8c",
          fr: "https://www.youtube.com/embed/8O1DoHX4c-8"
        }
      },
      {
        slug: "ProgramEB21",
        page_background: "media/images/water_mark_2.png"
      },
      {
        slug: "LRGdays2021",
        video_url: {
          en: "https://www.youtube.com/embed/Uoa3q4FZjSY",
          es: "https://www.youtube.com/embed/Uoa3q4FZjSY",
          fr: "https://www.youtube.com/embed/Uoa3q4FZjSY"
        }
      }
    ].freeze
  end
end
