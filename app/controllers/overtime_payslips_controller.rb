class OvertimePayslipsController < ApplicationController
  include ActsAsPayslipController

  private

  def available_params
    %i(hours applies_on issue_date)
  end
end
