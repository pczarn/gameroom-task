# Image uploader for game illustrations.
#
# More config options for default_url are available.
#
class ImageUploader < CarrierWave::Uploader::Base
  # Use MiniMagick instead of RMagick
  include CarrierWave::MiniMagick

  # The kind of storage to use for this uploader:
  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    base = if Rails.env.test?
      "#{Rails.root}/spec/support/uploads"
    else
      "uploads"
    end
    File.join(base, model.class.to_s.underscore, mounted_as.to_s, model.id.to_s)
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    "/images/fallback/" + [version_name, "default.png"].compact.join("_")
  end

  # Process files as they are uploaded:
  process resize_to_fit: [400, 400]

  # Create different versions of your uploaded files:
  version :thumb do
    process resize_to_fit: [50, 50]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  # Delete cache garbage directories

  # remember the tmp file
  def cache!(new_file)
    super
    @old_tmp_file = new_file
  end

  def delete_old_tmp_file(_dummy)
    @old_tmp_file.try :delete
  end
end
