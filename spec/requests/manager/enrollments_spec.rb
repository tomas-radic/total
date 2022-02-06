require 'rails_helper'
require 'shared_examples/manager_examples'

RSpec.describe "Manager::Enrollments", type: :request do

  describe "POST /manager/enrollments/toggle" do
    subject { post manager_toggle_enrollment_path(player_id: player.id) }

    it_behaves_like "manager_request"


    let!(:season) { create(:season) }
    let!(:player) { create(:player) }
    let!(:manager) { create(:manager) }

    context "As a signed in manager" do
      before { sign_in manager }

      context "When given player has no enrollment for managed season" do

        it "Creates enrollment for the player" do
          expect { subject }.to change { Enrollment.count }.by(1)

          latest_enrollment = Enrollment.order(:created_at).last
          expect(latest_enrollment).to have_attributes(
                                         season_id: season.id,
                                         player_id: player.id,
                                         canceled_at: nil)
        end

      end

      context "When given player has existing canceled enrollment for managed season" do
        let!(:enrollment) { create(:enrollment, player: player, season: season, canceled_at: 1.day.ago) }

        it "Uncancels player's enrollment" do
          expect { subject }.not_to change { Enrollment.count }

          expect(enrollment.reload.canceled_at).to be_nil
        end

      end

      context "When given player has uncanceled existing enrollment for managed season" do
        let!(:enrollment) { create(:enrollment, player: player, season: season, canceled_at: nil) }

        it "Cancels player's enrollment" do
          expect { subject }.not_to change { Enrollment.count }

          expect(enrollment.reload.canceled_at).not_to be_nil
        end

      end

    end

  end

end
