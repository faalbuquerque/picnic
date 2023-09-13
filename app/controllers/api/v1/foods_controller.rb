class Api::V1::FoodsController < Api::V1::ApiController
  def index
    @foods = Food.all

    render json: { foods: @foods.as_json(except: %i[created_at updated_at]) }
  end

  def show
    @food = food.find(params[:id])

    render json: { food: @food.as_json(except: %i[created_at updated_at]) }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'Dado não existe!' }, status: :not_found
  end

  def create
    @food = Food.new(food_params)
    @food.save!

    render json: { food: @food.as_json(except: %i[created_at updated_at]) }, status: :created
  rescue ActionController::ParameterMissing
    render json: { message: 'Dados inválidos!' }, status: :precondition_failed
  rescue ActiveRecord::RecordInvalid
    render json: { message: @food.errors.full_messages }, status: :unprocessable_entity
  end

  def destroy
    @food = Food.find(params[:id])
    @food.destroy!

    render json: { message: 'Alimento apagado!' }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'Dado não existe!' }, status: :not_found
  end

  private

  def food_params
    params.require(:food).permit(:name, :basket_id)
  end
end
