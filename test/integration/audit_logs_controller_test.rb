# frozen_string_literal: true

require 'test_helper'

class AuditLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_tokens = login(users(:admin))
    @pos_tokens = login(users(:pos))
    @inventoryer_tokens = login(users(:inventoryer))
    @arriver_tokens = login(users(:arriver))
  end

  # get index
  test 'admin get index' do
    get 'http://localhost:3000/api/v1/audit_logs', headers: @admin_tokens
    assert_response :ok
  end

  test 'pos get index' do
    get 'http://localhost:3000/api/v1/audit_logs', headers: @pos_tokens
    assert_response :forbidden
  end

  test 'inventoryer get index' do
    get 'http://localhost:3000/api/v1/audit_logs', headers: @inventoryer_tokens
    assert_response :forbidden
  end

  test 'arriver get index' do
    get 'http://localhost:3000/api/v1/audit_logs', headers: @arriver_tokens
    assert_response :forbidden
  end
end

