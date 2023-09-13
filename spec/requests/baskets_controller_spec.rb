require 'rails_helper'

describe Api::V1::BasketsController do
  describe 'get api/v1/baskets' do
    context 'when exists baskets' do
      let!(:candy_basket) { create(:basket, name: 'Cesta de doces') }
      let!(:fruit_basket) { create(:basket, name: 'Cesta de frutas') }

      it 'returns baskets' do
        get '/api/v1/baskets'

        resp_hash = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(resp_hash['baskets'].first['name']).to eq('Cesta de doces')
        expect(resp_hash['baskets'].second['name']).to eq('Cesta de frutas')
      end
    end

    context 'when not exists baskets' do
      it 'not returns baskets' do
        get '/api/v1/baskets'

        resp_hash = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(resp_hash['baskets']).to be_empty
      end
    end
  end

  describe 'get api/v1/baskets/id' do
    context 'when exists foods in basket' do
      let!(:basket) { create(:basket, name: 'Cesta de café da manhã')}
      let!(:orange_jam) { create(:food, name: 'Geleia de laranja', basket: basket) }
      let!(:vegan_orange_jam_) { create(:food, name: 'Geleia de laranja', basket: basket) }
      let!(:apple) { create(:food, name: 'Macã', basket: basket) }

      let(:result) do
        {
          "id": basket.id,
          "name": "Cesta de café da manhã",
          "Geleia de laranja": 2,
          "Macã": 1
        }
      end

      it 'returns basket with foods quantity' do
        get "/api/v1/baskets/#{basket.id}"

        resp_hash = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(resp_hash['basket'].count).to eq(4)
        expect(resp_hash['basket'].deep_symbolize_keys).to eq(result)
      end
    end
  end

  describe 'post api/v1/baskets' do
    context 'when passing correct data' do
      it 'create basket' do
        post '/api/v1/baskets', params: { basket: { name: 'Cesta de piquenique'} }
        resp_hash = JSON.parse(response.body)

        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/json')
        expect(resp_hash['basket']['name']).to eq('Cesta de piquenique')
      end
    end

    context 'when the request body is not passed' do
      it 'not create basket' do
        post '/api/v1/baskets'

        expect(response).to have_http_status(:precondition_failed)
        expect(response.content_type).to include('application/json')
        expect(response.body).to include('Dados inválidos')
      end
    end

    context 'when mandatory fields are not passed' do
      it 'not create basket' do
        post '/api/v1/baskets', params: { basket: { name: ''} }
        resp_hash = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
        expect(resp_hash['message']).to include("Name can't be blank")
      end
    end
  end

  describe 'delete api/v1/baskets' do
    context 'when try deleting existing basket' do
      it 'successfully' do
        candy_basket = create(:basket, name: 'Cesta de doces')

        delete "/api/v1/baskets/#{candy_basket.id}"

        resp_hash = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(resp_hash['message']).to include('Cesta apagada!')
        expect(resp_hash).to_not include('Cesta de doces')
      end
    end

    context 'when try deleting not existing basket' do
      it 'failure' do
        candy_basket = create(:basket, name: 'Cesta de doces')

        delete "/api/v1/baskets/#{candy_basket.id}"
        delete "/api/v1/baskets/#{candy_basket.id}"

        resp_hash = JSON.parse(response.body)

        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to include('application/json')
        expect(resp_hash).to_not include('Cesta de doces')
        expect(resp_hash['message']).to include('Dado não existe!')
      end
    end
  end
end
