class Cluster < ApplicationRecord
  has_many :dbs, dependent: :destroy
  has_many :nodes, dependent: :destroy

  def colo
    ('snc1' if name.start_with?('snc1.')) ||
    ('sac1' if name.start_with?('sac1.')) ||
    ('dub1' if name.start_with?('dub1.')) ||
    ('snc1' if name.start_with?('us.')) ||
    ('dub1' if name.start_with?('eu.'))
  end

end
