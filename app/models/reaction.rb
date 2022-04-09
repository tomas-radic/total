class Reaction < ApplicationRecord

  belongs_to :player
  belongs_to :reactionable, polymorphic: true, counter_cache: true

end
