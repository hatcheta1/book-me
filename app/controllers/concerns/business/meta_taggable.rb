module Business::MetaTaggable
  extend ActiveSupport::Concern
  include Rails.application.routes.url_helpers

  def to_meta_tags
    tags = {
      site: "BookMe",
      title: name,
      description: meta_description,
      og: {
        title: name,
        description: meta_description,
        site_name: "BookMe",
      }
    }

    if logo.attached?
      tags[:image] = rails_blob_url(logo, only_path: true)
      tags[:og][:image] = rails_blob_url(logo, only_path: true)
    end

    tags
  end

  def meta_description
    "#{about}"
  end
end
