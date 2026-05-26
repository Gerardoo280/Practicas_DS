module Api
    class TareasController < ApplicationController
      before_action :set_tarea, only: [:show, :update, :destroy]

      def index
        objetivo = Objetivo.find(params[:objetivo_id])
        render json: objetivo.tareas
      end

      def show
        render json: @tarea
      end

      def create
        tarea = Tarea.new(tarea_params)
        tarea.objetivo_id = params[:objetivo_id]
        if tarea.save
          render json: tarea, status: :created
        else
          render json: { errors: tarea.errors }, status: :unprocessable_entity
        end
      end

      def update
        if @tarea.update(tarea_params)
          render json: @tarea
        else
          render json: { errors: @tarea.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        @tarea.destroy
        head :no_content
      end

      private

      def set_tarea
        @tarea = Tarea.find(params[:id])
      end

      def tarea_params
        params.require(:tarea).permit(:titulo, :completada, :prioridad, :fecha_limite, :objetivo_id)
      end
    end

end
