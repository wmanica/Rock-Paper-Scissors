require 'rails_helper'

RSpec.describe Games::RpsService, type: :service do
  let(:service) { described_class.new(player_params) }
  before { allow(Rails.logger).to receive(:error) }

  describe '#call' do
    context 'when player options is valid' do
      let(:player_params) { { throw: RockPaperScissor::OPTIONS[rand(3)].to_sym } }

      it 'returns true' do
        game_result = service.call
        expect(game_result).to eq(true)
      end
    end

    context 'when player options is invalid' do
      let(:player_params) { { throw: 'fire' } }

      it 'returns false' do
        game_result = service.call
        expect(game_result).to eq(false)
      end
    end

    context 'when a error occurs' do
      let(:player_params) { { throw: RockPaperScissor::OPTIONS[rand(3)].to_sym } }
      let(:error_message) { 'This is the error' }
      it 'logs the error' do
        double = described_class.new(player_params)
        allow(double).to receive(:score).and_raise(StandardError, error_message)

        double.call
        expect(Rails.logger).to have_received(:error).with(error_message)
      end
    end
  end
end
