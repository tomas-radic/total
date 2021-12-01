require "rails_helper"

RSpec.describe "Rankings", type: :model do
  it "Excludes players having no reviewed ranking-counted matches"
  it "Excludes players not enrolled to given season"
  it "Excludes anonymized players"
end
