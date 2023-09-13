require 'rails_helper'

describe Api::V1::FoodsController do
  describe 'get api/v1/foods' do
    context 'when exists foods' do
      let!(:banana_prata) { create(:food, name: 'Banana') }
      let!(:avocado) { create(:food, name: 'Abacate') }

      it 'returns foods' do
        get '/api/v1/foods'

        resp_hash = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(resp_hash['foods'].count).to eq(2)
      end
    end

    context 'when not exists foods' do
      it 'not returns foods' do
        get '/api/v1/foods'

        resp_hash = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(resp_hash['foods']).to be_empty
      end
    end
  end

  describe 'post api/v1/foods' do
    context 'when passing repeated foods' do
      let!(:basket) { create(:basket, name: 'Cesta de frutas') }

      it 'create food' do
        post '/api/v1/foods', params: { food: { name: 'Banana', basket_id: basket.id } }
        post '/api/v1/foods', params: { food: { name: 'Banana', basket_id: basket.id } }

        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/json')
        expect(basket.foods.count).to eq(2)
      end
    end

    context 'when passing different foods' do
      let!(:basket) { create(:basket, name: 'Cesta de frutas') }

      it 'create food' do
        post '/api/v1/foods', params: { food: { name: 'Banana', basket_id: basket.id } }
        post '/api/v1/foods', params: { food: { name: 'Doce de Goiaba', basket_id: basket.id } }

        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/json')
        expect(basket.foods.count).to eq(2)
      end
    end

    context 'when the request body is not passed' do
      it 'not create food' do
        post '/api/v1/foods'

        expect(response).to have_http_status(:precondition_failed)
        expect(response.content_type).to include('application/json')
        expect(response.body).to include('Dados inválidos')
      end
    end

    context 'when mandatory fields are not passed' do
      it 'not create food' do
        post '/api/v1/foods', params: { food: { name: ''} }
        resp_hash = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
        expect(resp_hash['message']).to include("Name can't be blank")
      end
    end
  end

  describe 'delete api/v1/foods' do
    context 'when try deleting existing food' do
      let!(:basket) { create(:basket, name: 'Cesta de café da manhã')}
      let!(:bread) { create(:food, name: 'Pão', basket: basket) }
      let!(:jelly) { create(:food, name: 'Geleia', basket: basket) }

      it 'successfully' do
        basket.foods

        delete "/api/v1/foods/#{bread.id}"

        resp_hash = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        expect(resp_hash['message']).to include('Alimento apagado!')
        expect(basket.foods.count).to eq(1)
      end
    end

    context 'when try deleting not existing food' do
      it 'failure' do
        bread = create(:food, name: 'Pão')

        delete "/api/v1/foods/#{bread.id}"
        delete "/api/v1/foods/#{bread.id}"

        resp_hash = JSON.parse(response.body)

        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to include('application/json')
        expect(resp_hash).to_not include('Pão')
        expect(resp_hash['message']).to include('Dado não existe!')
      end
    end
  end
end
