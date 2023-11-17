class FoodsController < ApplicationController
  before_action :set_food, only: [:destroy]

  def index
    @foodlist = current_user.foods
  end

  def new
    @food = Food.new
  end

  def create
    @food = Food.new(food_params)
    @food.user_id = current_user.id

    if @food.save
      redirect_to foods_path, notice: 'Food was successfully created.'
    else
      render :new
    end
  end

  def destroy
    if @food
      if @food.destroy
        redirect_to foods_path, notice: 'Successfully destroyed foodlist.'
      else
        flash[:error] = 'Error: Food could not be destroyed.'
        redirect_to foods_path
      end
    else
      flash[:error] = 'Error: Food not found.'
      redirect_to foods_path
    end
  end

  private

  def food_params
    params.require(:food).permit(:name, :measurement_unit, :price, :quantity)
  end

  def set_food
    @food = Food.find_by(id: params[:id])
  end
end
