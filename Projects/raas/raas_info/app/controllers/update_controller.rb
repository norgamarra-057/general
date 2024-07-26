class UpdateController < ApplicationController

  def run
    run_raas_info_updater
  end

  # can be run from rails console, just copy&paste:
  def run_raas_info_updater
    require 'raas_info_updater'
    require 'open-uri'
    # Rails.logger = Logger.new(STDOUT)
    # Rails.logger.level = :debug
    # ActiveRecord::Base.logger = Rails.logger # log SQL queries
    begin
      Rails.logger.info "update_raas_info_db started"
      rladmin_status_by_cluster = JSON.parse open(Rails.configuration.rladmin_statuses).read
      api_dbs_by_hostname = JSON.parse open(Rails.configuration.apidbs).read
      updater = RaaSInfoUpdater.new(rladmin_status_by_cluster, api_dbs_by_hostname)
      updater.update
      Rails.logger.info "update_raas_info_db finished"
    rescue
      Rails.logger.error $!
    end
  end

end
