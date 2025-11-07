Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :employees do
        resource :salary, only: [:show]
      end
      
      namespace :metrics do
        get 'salaries/by_country', to: 'salaries#by_country'
        get 'salaries/by_job_title', to: 'salaries#by_job_title'
      end
    end
  end
end