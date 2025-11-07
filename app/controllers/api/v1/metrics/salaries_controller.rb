# app/controllers/api/v1/metrics/salaries_controller.rb
module Api
  module V1
    module Metrics
      class SalariesController < ApplicationController
        def by_country
          unless params[:country].present?
            return render json: { 
              error: 'Country parameter is required' 
            }, status: :bad_request
          end
          
          result = SalaryMetrics.by_country(params[:country])
          
          if result[:metrics].nil?
            render json: result, status: :not_found
          else
            render json: result
          end
        end
        
        def by_job_title
          unless params[:job_title].present?
            return render json: { 
              error: 'Job title parameter is required' 
            }, status: :bad_request
          end
          
          result = SalaryMetrics.by_job_title(params[:job_title])
          
          if result[:metrics].nil?
            render json: result, status: :not_found
          else
            render json: result
          end
        end
      end
    end
  end
end