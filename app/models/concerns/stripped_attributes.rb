module StrippedAttributes
  extend ActiveSupport::Concern

  class_methods do
    def has_stripped(*attr_names)
      @stripped_attr_names = attr_names
    end

    def stripped_attr_names
      @stripped_attr_names
    end
  end

  included do
    before_validation :strip_attributes
  end


  private

  def strip_attributes
    self.class.stripped_attr_names.each do |an|
      av = self.send(an)
      self.send("#{an}=", self.send(an).strip) unless av.nil?
    end
  end

end
