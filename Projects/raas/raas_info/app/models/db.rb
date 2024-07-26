class Db < ApplicationRecord
  belongs_to :cluster
  has_many :shards, dependent: :destroy
  has_many :endpoints, dependent: :destroy
end
