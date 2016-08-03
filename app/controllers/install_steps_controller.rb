class InstallStepsController < ApplicationController
  include Wicked::Wizard

  before_action :set_steps
  before_action :setup_wizard
  after_action :set_session

  # rescue_from Wicked::Wizard::InvalidStepError, with: ->{ redirect_to root_path }

  def show
    render_wizard
  end

  def update
    current_user.update(user_params)
    render_wizard current_user
  end

  private

  def set_steps
    case
    when mac?
      self.steps = mac_steps
    when windows?
      self.steps = windows_steps
    else
      self.steps = [:choose_os]
    end
  end

  def mac_steps
    [:choose_os, :open_terminal, :install_homebrew, :install_python, :verify_python, :using_pip, :config_virtualenv, :test_virtualenv, :getting_git, :pip_vs_pip3]
  end

  def windows_steps
    [:choose_os, :getting_python, :download_git_and_git_bash, :testing_python_and_git_bash, :getting_pip]
  end

  def finish_wizard_path
    congratulations_path
  end

  def user_params
    params.permit(:os, :os_version, :ruby_version, :rails_version)
  end

  def set_session
    session[:user] = current_user.config
  end
end
