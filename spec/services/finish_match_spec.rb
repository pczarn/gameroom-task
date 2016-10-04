require "rails_helper"

RSpec.describe FinishMatch do
  describe "#build_tasks" do
    subject(:run_service) do
      service.perform
    end

    let(:service) { described_class.new(match, current_user: user, params: params) }
    let(:params) { { team_one_score: 0, team_two_score: 0 } }
    let(:update_match) { instance_double("UpdateMatch") }
    let(:user) { build(:user) }

    before do
      allow(UpdateMatch).to receive(:new).and_return(update_match)
      allow(update_match).to receive_messages(save: true, finish: nil)
    end

    context "outside a tournament" do
      let(:match) { build(:match) }

      it "performs an update" do
        expect(update_match).to receive_messages(save: true, finish: nil)
        run_service
      end
    end

    context "with a tournament" do
      let(:tournament) { build(:tournament, :with_rounds, number_of_rounds: 2) }
      let(:round) { tournament.rounds.first }
      let(:match) { round.matches.first }

      before do
        allow(service).to receive(:editable?).and_return(true)
        allow(update_match).to receive_messages(save: nil, finish: nil)
      end

      it "performs an update" do
        expect(update_match).to receive(:save)
        run_service
      end

      context "when tournament is ended" do
        before { tournament.ended! }

        it "gives an alert" do
          run_service
          expect(service.alert).to be_a(String)
        end
      end

      context "when tournament is not editable" do
        before { allow(service).to receive(:editable?).and_return(false) }

        it "gives an alert" do
          run_service
          expect(service.alert).to be_a(String)
        end
      end

      context "when tournament is started and editable" do
        let(:create_next_match) { instance_double(CreateNextMatch) }
        let(:end_tournament) { instance_double(EndTournament) }

        before { expect(update_match).to receive_messages(save: true, finish: nil) }

        context "when match is not the last one" do
          it "builds the next match" do
            expect(CreateNextMatch).to receive(:new).and_return(create_next_match)
            expect(create_next_match).to receive_messages(save: true, finish: nil)
            run_service
          end
        end

        context "when match is the last one" do
          let(:round) { tournament.rounds.last }

          it "ends the tournament" do
            expect(EndTournament).to receive(:new).and_return(end_tournament)
            expect(end_tournament).to receive_messages(save: true, finish: nil)
            run_service
          end
        end
      end
    end
  end
end

RSpec.describe UpdateMatch do
  subject(:update_match) { described_class.new(match: match, params: params) }
  let(:match) { create(:match) }
  let(:params) { { team_one_score: 0, team_two_score: 0 } }

  describe "#save" do
    it "works" do
      expect { update_match.save }.not_to raise_error
    end
  end
end

RSpec.describe CreateNextMatch do
  subject(:create_next_match) do
    described_class.new(tournament: tournament, round: round, match: match)
  end

  let!(:tournament) { create(:tournament, :with_rounds, number_of_rounds: 2) }
  let(:round) { tournament.rounds.first }
  let(:match) { round.matches.first }
  let(:mail) { double("Message") }

  before do
    allow(described_class).to receive(:delay).and_return(described_class)
  end

  describe "#save" do
    it "saves the next match" do
      expect { create_next_match.save }.to change(Match, :count).by(1)
    end
  end

  describe "#finish" do
    it "sends mails about match result" do
      allow(TournamentStatusMailer).to receive(:notify_about_match_result).and_return(mail)
      expect(mail).to receive(:deliver).at_least(:once)
      create_next_match.finish
    end
  end
end

RSpec.describe EndTournament do
  let(:end_tournament) { described_class.new(tournament: tournament, match: match) }
  let(:tournament) { create(:tournament, :with_rounds) }
  let(:match) { tournament.rounds.first.matches.first }
  let(:mail) { double("Message") }

  before do
    allow(described_class).to receive(:delay).and_return(described_class)
  end

  describe "#save" do
    it "ends the tournament" do
      expect { end_tournament.save }.to change { tournament.reload.ended? }.to eq(true)
    end
  end

  describe "#finish" do
    before do
      tournament.teams = [build(:team)]
    end

    it "sends mails about tournament end" do
      allow(TournamentStatusMailer).to receive(:notify_about_end).and_return(mail)
      expect(mail).to receive(:deliver).at_least(:once)
      end_tournament.finish
    end
  end
end
