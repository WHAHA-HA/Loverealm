# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = 'http://www.loverealm.com/'

# store on S3 using Fog (pass in configuration values as shown above if needed)
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new({
  fog_provider: 'AWS',
  aws_access_key_id: ENV['AWS_KEY'],
  aws_secret_access_key: ENV['AWS_SECRET'],
  fog_directory: ENV['S3_BUCKET'],
  fog_region: ENV['FOG_REGION']
})

# pick a place safe to write the files
SitemapGenerator::Sitemap.public_path = 'tmp/'

# inform the map cross-linking where to find the other maps
SitemapGenerator::Sitemap.sitemaps_host = "http://#{ENV['S3_BUCKET']}.s3.amazonaws.com/"

# pick a namespace within your bucket to organize your maps
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  Content.find_each do |content|
    add dashboard_content_path(content), changefreq: 'daily'
  end

  HashTag.find_each do |tag|
    add dashboard_contents_path(tag_id: tag.id), changefreq: 'daily'
  end
end
