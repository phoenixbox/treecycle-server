class Package < ActiveRecord::Base
  PACKAGE_TYPES ||= YAML.load(File.open("#{Rails.root}/config/constants/package_types.yml", 'r'))

  # Enums
  as_enum :type, PACKAGE_TYPES

  # Associations
  belongs_to :order
end
