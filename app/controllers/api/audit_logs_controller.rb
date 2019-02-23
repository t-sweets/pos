# frozen_string_literal: true

class Api::AuditLogsController < ApplicationController
  before_action :authenticate_admin, only: [:index]

  def index
    @audit_logs = AuditLog.all
    render json: @audit_logs
  end
end
