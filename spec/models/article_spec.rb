require 'rails_helper'

RSpec.describe Article, type: :model do

  subject { build(:article) }

  it "Has valid factory" do
    expect(subject).to be_valid
  end
end
