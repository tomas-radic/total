class Tournament < ApplicationRecord

  include ColorBase

  before_validation :set_random_color_base


  # Relations ----------
  belongs_to :season
  belongs_to :place, optional: true
  has_many :matches, as: :competitable

  # Validations --------
  validates :name, :main_info, :color_base,
            presence: true
  validates :begin_date, :end_date,
            presence: true, if: Proc.new { |t| t.published_at.present? }

  # Scopes --------
  scope :published, -> { where.not(published_at: nil) }
  scope :sorted, -> { order(begin_date: :desc, updated_at: :desc) }

end
