class Node < ApplicationRecord
  belongs_to :cluster
  has_many :shards, dependent: :destroy
  has_many :endpoints, dependent: :destroy

  def fqdn
    "#{hostname}.#{colo}" if hostname && !hostname.empty?
  end

  def colo
    colo = "#{rack[0..2].downcase}1"
    raise "cannot infer colo from rack #{rack}" unless ['snc1', 'sac1', 'dub1'].include?(colo)
    colo
  end
end
