require 'rails_helper'
require 'shared_examples/manager_examples'

RSpec.describe "Manager::Tournaments", type: :request do

  let!(:manager) { create(:manager) }
  let!(:player) { create(:player, email: manager.email) }

  describe "GET /manager/tournaments" do
    subject { get manager_tournaments_path }

    it_behaves_like "manager_request"

    context "As a logged in manager" do
      before { sign_in manager }

      context "Whit no existing season" do
        it "Redirects" do
          subject

          expect(response).to redirect_to(manager_pages_dashboard_path)
        end
      end

      context "With existing seasons" do
        let!(:season) { create(:season) }

        it "Renders page" do
          subject

          expect(response).to render_template(:index)
        end
      end
    end
  end


  describe "GET /managers/tournaments/new" do
    subject { get new_manager_tournament_path }

    it_behaves_like "manager_request"

    context "As a logged in manager" do
      before { sign_in manager }

      context "Whit no existing season" do
        it "Redirects" do
          subject

          expect(response).to redirect_to(manager_pages_dashboard_path)
        end
      end

      context "With existing season" do
        let!(:season) { create(:season) }

        it "Renders page" do
          subject

          expect(response).to render_template(:new)
        end
      end
    end
  end


  describe "POST /manager/tournaments" do
    subject { post manager_tournaments_path(params: params) }

    let(:valid_params) do
      {
        tournament: {
          name: "Wimbledon",
          main_info: "main_info",
          color_base: "base_green"
        }
      }
    end
    let(:invalid_params) do
      {
        tournament: {
          name: "",
          main_info: "main_info",
        }
      }
    end

    context "As a logged in manager" do
      before { sign_in manager }

      let!(:season) { create(:season) }

      context "With valid params" do
        let(:params) { valid_params }

        it_behaves_like "manager_request"

        it "Creates tournament and redirects" do
          subject

          expect(Tournament.order(created_at: :desc).first).to have_attributes(valid_params[:tournament])
          expect(response).to redirect_to(manager_tournaments_path)
        end
      end

      context "With invalid params" do
        let(:params) { invalid_params }

        it_behaves_like "manager_request"

        it "Renders new" do
          subject

          expect(Tournament.count).to eq(0)
          expect(response).to render_template(:new)
        end
      end
    end
  end


  describe "GET /manager/tournaments/:id" do
    subject { get edit_manager_tournament_path(tournament) }

    context "As a logged in manager" do
      before { sign_in manager }

      context "With tournament within managed season" do
        let!(:season) { create(:season) }
        let!(:tournament) { create(:tournament, season: season) }

        it_behaves_like "manager_request"

        it "Renders page" do
          subject

          expect(response).to render_template(:edit)
        end
      end


      context "Without tournament within managed season" do
        let!(:ended_season) { create(:season, :ended) }
        let!(:season) { create(:season) }
        let!(:tournament) { create(:tournament, season: ended_season) }

        it_behaves_like "manager_request"

        it "Renders page" do
          subject

          expect(response).to redirect_to("/not_found")
        end
      end
    end
  end


  describe "PATCH /manager/tournaments/:id" do
    subject { patch manager_tournament_path(tournament, params: params) }

    let(:valid_params) { { tournament: { name: "Wimbledon" } } }
    let(:invalid_params) { { tournament: { name: "" } } }

    context "As a logged in manager" do
      before { sign_in manager }

      context "With tournament within managed season" do
        let!(:season) { create(:season) }
        let!(:tournament) { create(:tournament, season: season) }

        context "With valid params" do
          let(:params) { valid_params }

          it_behaves_like "manager_request"

          it "Updates tournament and redirects" do
            subject

            tournament.reload
            expect(tournament.name).to eq(valid_params[:tournament][:name])
            expect(response).to redirect_to(manager_tournaments_path)
          end
        end

        context "With invalid params" do
          let(:params) { invalid_params }

          it_behaves_like "manager_request"

          it "Renders edit" do
            subject

            tournament.reload
            expect(tournament.name).not_to eq(valid_params[:name])
            expect(response).to render_template(:edit)
          end
        end
      end


      context "Without tournament within managed season" do
        let!(:ended_season) { create(:season, :ended) }
        let!(:season) { create(:season) }
        let!(:tournament) { create(:tournament, season: ended_season) }
        let(:params) { valid_params }

        it_behaves_like "manager_request"

        it "Renders page" do
          subject

          expect(response).to redirect_to("/not_found")
        end
      end
    end
  end

end
