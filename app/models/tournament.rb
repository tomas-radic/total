class Tournament < ApplicationRecord

  before_validation :set_defaults


  # Relations ----------
  belongs_to :season

  # Validations --------
  validates :name, :main_info,
            presence: true
  validates :begin_date, :end_date,
            presence: true, if: Proc.new { |t| t.published_at.present? }

  # Scopes --------
  scope :published, -> { where.not(published_at: nil) }
  scope :sorted, -> { order(begin_date: :desc, updated_at: :desc) }


  # Enums ---------
  enum color_base: {
    "base-green" => 0,
    "base-yellow" => 1,
    "base-salmon" => 2,
    "base-red" => 3
  }


  private

  def set_defaults
    self.color_base ||= self.class.color_bases.keys.sample
  end

end
