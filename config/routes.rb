Rails.application.routes.draw do
  resources :employees, except: :show do
    resources :salary_advances, except: :show
    resources :salary_payslips, except: %i(edit update)
  end

  resources :salary_advances, only: %i(index edit update destroy)
  resources :salary_payslips, only: %i(index show destroy)

  root to: 'employees#index'
end
