class TriggersController < ApplicationController
  http_basic_authenticate_with :name => Rails.configuration.basic_auth_username,
                               :password => Rails.configuration.basic_auth_password,
                               :only => [:show_crontab, :trigger]

  before_filter :must_ssl, :only => [:showtab, :trigger]

  respond_to :html, :js
  respond_to :text, :only => [:show_crontab, :trigger]

  def index
    @service = Service.find(params[:service_id])
    unless @service.meta(current_user)
      auth_url = @service.auth session, auth_callback_service_url(@service)
      if auth_url
        render 'triggers/service_auth'
        return
      end
      @service.auth_meta current_user, session
    end

    @triggers = @service.triggers
    respond_with @triggers
  end

  def show_crontab
    @periods = Trigger.all.inject({}) do |o, t|
      o.merge! t.period => 1
    end.keys
    respond_with @periods
  end

  def trigger
    tasks = Task.where "trigger_id IN (SELECT id FROM triggers WHERE period='#{params[:period]}')"
    tasks.each { |t| t.run }
  end
end
