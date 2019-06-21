class StoresController < ApplicationController
  def index
    stores = Store.all
    render json: stores
  end
end
