class Phone < ActiveRecord::Base
  # Associations
  belongs_to :phoneable, polymorphic: true
end
