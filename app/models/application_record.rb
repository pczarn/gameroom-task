# Used for keeping `ActiveRecord::Base` cleaner so that it can be used not only in models.
#
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
