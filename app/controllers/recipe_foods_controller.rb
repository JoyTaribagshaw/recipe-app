class RecipeFoodsController < ApplicationController
  before_action :set_recipe_food, only: [:edit, :update, :destroy]

  def new
    @recipe_food = RecipeFood.new
  end

  def edit
    # No need to find the recipe_food here; it's handled by the before_action
    # @recipe_food = RecipeFood.find(params[:id])
  end

  def create
    @recipe_food = RecipeFood.new(recipe_food_params)
    @recipe_food.recipe_id = params[:recipe_id]
    if @recipe_food.save
      flash[:success] = 'Ingredient added successfully!'
      redirect_to recipe_path(params[:recipe_id])
    else
      flash.now[:error] = 'Error: ingredient could not be added!'
      render :new, locals: { recipe_food: @recipe_food }
    end
  end

  def destroy
    if @recipe_food
      @recipe_food.destroy
      flash[:success] = 'Ingredient was deleted successfully!'
    else
      flash[:error] = 'Error: Ingredient not found!'
    end
    redirect_to recipe_path(params[:recipe_id])
  end

  def update
    if @recipe_food
      if @recipe_food.update(recipe_food_params)
        flash[:notice] = 'Ingredient updated successfully!'
        redirect_to recipe_path(params[:recipe_id])
      else
        flash.now[:error] = 'Error: ingredient could not be updated!'
        render :edit, locals: { recipe_food: @recipe_food }
      end
    else
      flash[:error] = 'Error: Ingredient not found!'
      redirect_to recipe_path(params[:recipe_id])
    end
  end

  private

  def recipe_food_params
    params.require(:recipe_food).permit(:quantity, :food_id)
  end

  def set_recipe_food
    @recipe_food = RecipeFood.find_by(id: params[:id])
    redirect_to recipe_path(params[:recipe_id]) unless @recipe_food
  end
end
