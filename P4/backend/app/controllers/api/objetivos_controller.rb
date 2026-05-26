module Api
    class ObjetivosController < ApplicationController
      before_action :set_objetivo, only: [:show, :update, :destroy]

      def index
        proyecto = Proyecto.find(params[:proyecto_id])
        render json: proyecto.objetivos
      end

      def show
        render json: @objetivo
      end

      def create
        objetivo = Objetivo.new(objetivo_params)
        objetivo.proyecto_id = params[:proyecto_id]
        if objetivo.save
          render json: objetivo, status: :created
        else
          render json: { errors: objetivo.errors }, status: :unprocessable_entity
        end
      end

      def update
        if @objetivo.update(objetivo_params)
          render json: @objetivo
        else
          render json: { errors: @objetivo.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        @objetivo.destroy
        head :no_content
      end

      private

      def set_objetivo
        @objetivo = Objetivo.find(params[:id])
      end

      def objetivo_params
        params.require(:objetivo).permit(:nombre, :proyecto_id)
      end
    end

end
