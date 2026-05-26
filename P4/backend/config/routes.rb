Rails.application.routes.draw do
  namespace :api do
    resources :proyectos do
      resources :objetivos, shallow: true do
        resources :tareas, shallow: true
      end
    end
  end
end
