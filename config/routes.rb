Rails.application.routes.draw do
  resources :employees, except: :show do
    Deductions::TYPES.each do |advance|
      resources advance, except: :show
    end

    Payslips::TYPES.each do |payslip|
      resources payslip, except: %i(edit update)
    end
  end

  Deductions::TYPES.each do |advance|
    resources advance, only: %i(index show edit update destroy)
  end

  Payslips::TYPES.each do |payslip|
    resources payslip, only: %i(index show destroy)
  end

  post :attendances, to: 'attendances#create'

  root to: 'employees#index'
end
