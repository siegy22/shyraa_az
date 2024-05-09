class ApplicationController < ActionController::Base
  def default_meta_tags
    {
      title: "Shyraa's A-Z Challenge",
      reverse: true,
      separator: '|',
      keywords: 'shyraa, lol, league of legends, challenge',
      canonical: request.original_url,
      noindex: !Rails.env.production?,
      og: {
        title: "Shyraa's A-Z Challenge",
        type: 'website',
        url: request.original_url,
      }
    }
  end
  helper_method :default_meta_tags
end
