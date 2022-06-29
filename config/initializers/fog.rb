CarrierWave.configure do |config|
  # For testing, upload files to local `tmp` folder.
  if Rails.env.test? || Rails.env.cucumber? # || Rails.env.development?
    config.storage = :file
    config.enable_processing = false
    config.root = "#{Rails.root}/tmp"
  else
    config.storage = :fog
  end

  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: 'AKIAJIEHISEYRC7J2FMA',
    aws_secret_access_key: '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',
    region: 'eu-west-1'
  }

  config.cache_dir = "#{Rails.root}/tmp/uploads" # To let CarrierWave work on heroku

  config.fog_directory = 'loverealm'
end
