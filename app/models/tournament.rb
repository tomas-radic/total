class Tournament < ApplicationRecord

  before_validation :set_defaults


  # Relations ----------
  belongs_to :season
  has_many :matches, as: :competitable

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
    base_green: 0,
    base_yellow: 1,
    base_salmon: 2,
    base_red: 3
  }


  # Methods -------

  def color_base_css
    color_base.gsub('_', '-') if color_base
  end


  private

  def set_defaults
    self.color_base ||= self.class.color_bases.keys.sample
  end

end
