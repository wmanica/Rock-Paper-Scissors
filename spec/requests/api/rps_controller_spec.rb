require 'rails_helper'

RSpec.describe 'API::RpsController', type: :request do
  let(:url) { '/api/rps' }
  let(:json) { JSON.parse(response.body) }
  before do
    post url, params: params
  end

  context 'with valid params' do
    let(:params) { { player_throw: { throw: RockPaperScissor::OPTIONS[rand(3)].to_s } } }

    it 'responds with a status 200' do
      expect(response.status).to eq 200
    end

    it 'responds with a json body' do
      expect(response.media_type).to eq('application/json')
      expect { json }.to_not raise_error
    end
  end

  context 'with invalid params' do
    let(:params) { { player_throw: { throw: 'fire'} } }

    it 'responds with a status 200' do
      expect(response.status).to eq 400
    end

    it 'responds with a error message' do
      expect(json['error']).to eq("The option is not valid. Retry with one of these: "\
                                  "#{RockPaperScissor::OPTIONS.join(' or ')}")
    end
  end
end
