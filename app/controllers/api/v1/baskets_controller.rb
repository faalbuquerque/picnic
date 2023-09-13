class Api::V1::BasketsController < Api::V1::ApiController
  def index
    @baskets = Basket.all

    render json: { baskets: @baskets.as_json(except: %i[created_at updated_at], include: :foods) }
  end

  def show
    @basket = Basket.find(params[:id])
    @qtd_foods = @basket.foods.group(:name).count

    render json: { basket: @basket.as_json(except: %i[created_at updated_at]).merge(@qtd_foods) }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'Dado não existe!' }, status: :not_found
  end

  def create
    @basket = Basket.new(basket_params)
    @basket.save!

    render json: { basket: @basket.as_json(except: %i[created_at updated_at]) }, status: :created
  rescue ActionController::ParameterMissing
    render json: { message: 'Dados inválidos!' }, status: :precondition_failed
  rescue ActiveRecord::RecordInvalid
    render json: { message: @basket.errors.full_messages }, status: :unprocessable_entity
  end

  def destroy
    @basket = Basket.find(params[:id])
    @basket.destroy!

    render json: { message: 'Cesta apagada!' }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'Dado não existe!' }, status: :not_found
  end

  private

  def basket_params
    params.require(:basket).permit(:name)
  end
end
