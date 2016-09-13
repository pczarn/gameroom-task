class GamesController < ApplicationController
  def create
    redirect_to action: :index
  end

  def index
  end

  def show
  end

  def update
    redirect_to action: :index
  end

  def destroy
    redirect_to action: :index
  end
end
