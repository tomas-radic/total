require 'rails_helper'
require 'shared_examples/player_examples'

RSpec.describe "Player::Comments", type: :request do

  let!(:season) { create(:season) }
  let!(:match) { create(:match, competitable: season) }
  let!(:player) { create(:player, seasons: [season]) }
  let(:attributes) do
    {
      comment: { content: "hello", motive_id: create(:comment, commentable: match).id }
    }
  end

  let(:invalid_attributes) do
    {
      comment: { content: "" }
    }
  end


  describe "POST /player/matches/:match_id/comments" do
    subject { post player_match_comments_path(match_id: match, params: attributes) }

    it_behaves_like "player_request"

    context "When player is logged in" do

      before do
        sign_in player
      end

      context "With valid attributes" do
        it "Creates new comment" do
          subject

          expect(player.reload.comments.find_by(content: attributes[:comment][:content])).not_to be_nil
        end
      end

      context "With invalid attributes" do
        let(:attributes) { invalid_attributes }

        it "Does not create comment and renders matches/show template" do
          subject

          expect(response).to render_template("player/comments/_form")
          expect(player.reload.comments.count).to be(0)
        end

      end

      context "When player is restricted to comment" do
        before { player.update_column(:comments_disabled_since, Time.now) }

        it "Does not create comment and redirects" do
          subject

          expect(response).to redirect_to(root_path)
          expect(player.reload.comments.count).to be(0)
        end
      end

      context "When it is not allowed to comment that match" do
        before { match.update_column(:comments_disabled_since, Time.now) }

        it "Does not create comment and redirects" do
          subject

          expect(response).to redirect_to(not_found_path)
          expect(player.reload.comments.count).to be(0)
        end
      end

      context "When match is not published" do
        before { match.update_column(:published_at, nil) }

        it "Does not create comment and redirects" do
          subject

          expect(response).to redirect_to(not_found_path)
          expect(player.reload.comments.count).to be(0)
        end
      end
    end

  end


  describe "GET /player/matches/:match_id/comments/:id/edit" do
    subject { get edit_player_match_comment_path(comment, match_id: match) }

    let!(:comment) { create(:comment, commentable: match) }

    it_behaves_like "player_request"

    context "When player is logged in" do

      before do
        sign_in player
      end

      context "With comment of signed in player" do
        before { comment.update_column(:player_id, player.id) }

        it "Renders template" do
          subject

          expect(response).to render_template("player/comments/edit")
        end

        context "When player is restricted to comment" do
          before { player.update_column(:comments_disabled_since, Time.now) }

          it "Redirects to root" do
            subject

            expect(response).to redirect_to(root_path)
          end
        end

        context "When it is not allowed to comment that match" do
          before { match.update_column(:comments_disabled_since, Time.now) }

          it "Redirects to not found" do
            subject

            expect(response).to redirect_to(not_found_path)
          end
        end

        context "When match is not published" do
          before { match.update_column(:published_at, nil) }

          it "Redirects to root" do
            subject

            expect(response).to redirect_to(not_found_path)
          end
        end
      end

      context "With comment of different player" do
        it "Redirects to root" do
          subject

          expect(response).to redirect_to(not_found_path)
        end
      end
    end
  end


  describe "PUT /player/matches/:match_id/comments/:id" do
    subject { put player_match_comment_path(comment, match_id: match, params: attributes) }

    let!(:comment) { create(:comment, commentable: match) }

    it_behaves_like "player_request"

    context "When player is logged in" do

      before do
        sign_in player
      end

      context "With comment of signed in player" do
        before { comment.update_column(:player_id, player.id) }

        context "With valid attributes" do
          it "Updates comment" do
            subject

            expect(comment.reload.content).to eq(attributes[:comment][:content])
          end

          context "When player is restricted to comment" do
            before { player.update_column(:comments_disabled_since, Time.now) }

            it "Redirects to root" do
              subject

              expect(response).to redirect_to(root_path)
            end
          end

          context "When it is not allowed to comment that match" do
            before { match.update_column(:comments_disabled_since, Time.now) }

            it "Redirects to not found" do
              subject

              expect(response).to redirect_to(not_found_path)
            end
          end

          context "When match is not published" do
            before { match.update_column(:published_at, nil) }

            it "Does not update comment" do
              subject

              expect(comment.reload.content).not_to eq(attributes[:comment][:content])
            end
          end
        end

        context "With invalid attributes" do
          let(:attributes) { invalid_attributes }

          it "Does not update comment and renders template" do
            subject

            expect(comment.reload.content).not_to eq(attributes[:comment][:content])
            expect(response).to render_template("player/comments/edit")
          end
        end
      end

      context "With comment of different player" do
        it "Redirects to root" do
          subject

          expect(response).to redirect_to(not_found_path)
        end
      end
    end
  end


  describe "POST /player/matches/:match_id/comments/:id/delete" do
    subject { post delete_player_match_comment_path(comment, match_id: match.id) }

    let!(:comment) { create(:comment, commentable: match) }

    it_behaves_like "player_request"

    context "When player is logged in" do

      before do
        sign_in player
      end

      context "With comment of signed in player" do
        before { comment.update_column(:player_id, player.id) }

        it "Marks comment deleted and redirects" do
          subject

          expect(comment.reload.deleted_at).not_to be_nil
        end

        context "When player is restricted to comment" do
          before { player.update_column(:comments_disabled_since, Time.now) }

          it "Marks comment deleted and redirects" do
            subject

            expect(comment.reload.deleted_at).not_to be_nil
          end
        end

        context "When it is not allowed to comment that match" do
          before { match.update_column(:comments_disabled_since, Time.now) }

          it "Does not mark comment deleted" do
            subject

            expect(comment.reload.deleted_at).to be_nil
          end
        end

        context "When match is not published" do
          before { match.update_column(:published_at, nil) }

          it "Does not mark comment deleted" do
            subject

            expect(comment.reload.deleted_at).to be_nil
          end
        end
      end

      context "With comment of different player" do
        it "Redirects to root" do
          subject

          expect(response).to redirect_to(not_found_path)
        end
      end
    end
  end

end
