module ColorBase
  extend ActiveSupport::Concern


  included do

    # Enums ---------
    enum color_base: {
      base_green: 0,
      base_yellow: 1,
      base_salmon: 2,
      base_red: 3
    }

  end


  # Methods -------

  def color_base_css
    color_base.gsub('_', '-') if color_base
  end


  private

  def set_random_color_base
    self.color_base ||= self.class.color_bases.keys.sample
  end

end
