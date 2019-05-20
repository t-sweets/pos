# frozen_string_literal: true

require 'test_helper'

class RegistersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_tokens = login(users(:admin))
    @pos_tokens = login(users(:pos))
    @inventoryer_tokens = login(users(:inventoryer))
    @arriver_tokens = login(users(:arriver))
  end

  # get balance
  test 'admin get index' do
    get 'http://localhost:3000/api/v1/registers/balances', headers: @admin_tokens
    assert_response :ok
  end

  test 'pos get index' do
    get 'http://localhost:3000/api/v1/registers/balances', headers: @pos_tokens
    assert_response :forbidden
  end

  test 'inventoryer get index' do
    get 'http://localhost:3000/api/v1/registers/balances', headers: @inventoryer_tokens
    assert_response :ok
  end

  test 'arriver get index' do
    get 'http://localhost:3000/api/v1/registers/balances', headers: @arriver_tokens
    assert_response :forbidden
  end

  # check
  test 'admin check' do
    param = {
      cash_amount: 7500
    }

    post 'http://localhost:3000/api/v1/registers/check', headers: @admin_tokens, params: param, as: :json
    assert_response :ok

    check = RegiCheck.last
    assert_equal check.register_cash_amount, param[:cash_amount]
  end

  test 'pos check' do
    param = {
      cash_amount: 7500
    }

    post 'http://localhost:3000/api/v1/registers/check', headers: @pos_tokens, params: param, as: :json
    assert_response :forbidden
  end

  test 'inventoryer check' do
    param = {
      cash_amount: 7500
    }

    post 'http://localhost:3000/api/v1/registers/check', headers: @inventoryer_tokens, params: param, as: :json
    assert_response :ok

    check = RegiCheck.last
    assert_equal check.register_cash_amount, param[:cash_amount]
  end

  test 'arriver check' do
    param = {
      cash_amount: 7500
    }

    post 'http://localhost:3000/api/v1/registers/check', headers: @arriver_tokens, params: param, as: :json
    assert_response :forbidden
  end
end
