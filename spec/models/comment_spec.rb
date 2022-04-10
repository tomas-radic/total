require 'rails_helper'

RSpec.describe Comment, type: :model do
  subject { build(:comment) }

  let!(:season) { create(:season) }

  describe "Validations" do

    context "Refers different commentable than its motive" do
      let!(:match) { create(:match, competitable: season) }
      let!(:match_comment) { create(:comment, commentable: match) }

      before do
        subject.motive = match_comment
        subject.commentable = create(:match, competitable: season)
      end

      it "Is invalid" do
        expect(subject).not_to be_valid
        expect(subject.errors.messages[:commentable]).to include("sa nezhoduje")
      end
    end
  end
end
