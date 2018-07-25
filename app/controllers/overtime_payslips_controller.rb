class OvertimePayslipsController < ApplicationController
  include ActsAsPayslipController

  private

  def available_params
    %i(hours applies_on)
  end
end
