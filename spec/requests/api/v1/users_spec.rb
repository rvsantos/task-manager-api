require 'rails_helper'

describe 'Users API', type: :request do
  let!(:user) { create(:user) }
  let(:user_id) { user.id }
  let(:headers) do
     {
       Accept: 'application/vnd.taskmanager.v1',
      'Content-Type': 'application/json'
      }
  end

  before { host! 'api.taskmanager.test' }

  describe 'GET /users/:id' do
    before do
      get "/users/#{user_id}", params: {}, headers: headers
    end

    context 'when the user exists' do
      it 'return the user' do
        json_body = JSON.parse(response.body, symbolize_names: true)
        expect(json_body[:id]).to eq(user_id)
      end

      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the user does not exist' do
      let(:user_id) { 1000 }
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST /users' do
    before do
      post '/users', params: { user: user_params }.to_json , headers: headers
    end

    context 'when the request params are valid' do
      let(:user_params) { attributes_for(:user) }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns json data for the created user' do
        json_body = JSON.parse(response.body, symbolize_names: true)
        expect(json_body[:email]).to eq(user_params[:email])
      end
    end

    context 'when the request params are invalid' do
      let(:user_params) { attributes_for(:user_invalid_email) }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns the json data for the errors' do
        json_body = JSON.parse(response.body, symbolize_names: true)
        expect(json_body).to have_key(:errors)
      end
    end
  end
end