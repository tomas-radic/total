class Tournament < ApplicationRecord

  include ColorBase
  include Reactions

  before_validation :set_random_color_base


  # Relations ----------
  belongs_to :season
  belongs_to :place, optional: true
  has_many :matches, as: :competitable

  # Validations --------
  validates :name, :main_info, :color_base,
            presence: true
  validates :begin_date, :end_date,
            presence: true, if: Proc.new { |t| t.published? }

  # Scopes --------
  scope :published, -> { where.not(published_at: nil) }
  scope :sorted, -> { order(begin_date: :desc, updated_at: :desc) }


  def date
    result = ""

    if begin_date.present?
      result = ApplicationController.helpers.app_date begin_date

      if end_date.present? && end_date > begin_date
        result += " - #{ApplicationController.helpers.app_date end_date}"
      end
    end

    result
  end


  def published?
    published_at.present?
  end

end
