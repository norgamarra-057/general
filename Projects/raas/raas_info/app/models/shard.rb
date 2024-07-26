class Shard < ApplicationRecord
  belongs_to :db
  belongs_to :node
end
