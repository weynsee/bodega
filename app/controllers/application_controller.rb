class ApplicationController < ActionController::Base
  include Pagy::Backend

  helper_method :employee_context?
  helper_method :print_preview?

  private

  def employee_context?
    params[:employee_id].present?
  end

  def employee
    @employee ||= Employee.find(params[:employee_id])
  end

  def print_preview?
    params[:printer] == 'true'
  end
end
