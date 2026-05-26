module Api
  class ProyectosController < ApplicationController
    before_action :set_proyecto, only: [:show, :update, :destroy]

    def index
      render json: Proyecto.all
    end

    def show
      render json: @proyecto
    end

    def create
      proyecto = Proyecto.new(proyecto_params)
      if proyecto.save
        render json: proyecto, status: :created
      else
        render json: { errors: proyecto.errors }, status: :unprocessable_entity
      end
    end

    def update
      if @proyecto.update(proyecto_params)
        render json: @proyecto
      else
        render json: { errors: @proyecto.errors }, status: :unprocessable_entity
      end
    end

    def destroy
      @proyecto.destroy
      head :no_content
    end

    private

    def set_proyecto
      @proyecto = Proyecto.find(params[:id])
    end

    def proyecto_params
      params.require(:proyecto).permit(:nombre, :descripcion)
    end
  end
end
