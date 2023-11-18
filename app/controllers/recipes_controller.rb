class RecipesController < ApplicationController
  load_and_authorize_resource

  def index
    @recipes = current_user.recipes.order(id: :asc)
  end

  def show
    @recipe = Recipe.find(params[:id])
    @recipe_foods = RecipeFood.where(recipe_id: params[:id])
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user = current_user
    if @recipe.save
      flash[:success] = 'Recipe created successfully!'
      redirect_to recipes_url
    else
      flash.now[:error] = 'Error: Recipe could not be created!'
      render :new, locals: { recipe: @recipe }
    end
  end

  def destroy
    @recipe = Recipe.find(params[:id])

    if @recipe.destroy
      flash[:success] = 'Recipe was deleted successfully!'
    else
      flash[:error] = 'Error: Recipe could not be deleted!'
    end

    redirect_to recipes_url
  end

  def update
    @recipe = Recipe.find(params[:id])

    if @recipe.update(public: !@recipe.public)
      flash[:notice] = @recipe.public ? 'Recipe status changed to public' : 'Recipe status changed to private'
    else
      flash[:error] = 'Error: Recipe status could not be changed!'
    end

    redirect_to recipe_path
  end

  def public_recipes
    @recipes = Recipe.where(public: true).order(id: :desc)
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :preparation_time, :cooking_time, :description, :public)
  end
end
