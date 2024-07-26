class Endpoint < ApplicationRecord
  belongs_to :db
  belongs_to :node, optional: true
end
