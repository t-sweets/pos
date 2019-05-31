# frozen_string_literal: true

require 'test_helper'

class DepositsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_tokens = login(users(:admin))
    @pos_tokens = login(users(:pos))
    @inventoryer_tokens = login(users(:inventoryer))
    @arriver_tokens = login(users(:arriver))
  end

  # create
  test 'admin create' do
    param = {
      amount: 2000,
      detail: 'okodukai from boss'
    }

    post 'http://localhost:3000/api/v1/deposits', headers: @admin_tokens, params: param, as: :json
    assert_response :ok

    deposit = Deposit.last
    assert_equal deposit.amount, param[:amount]
  end

  test 'pos create' do
    param = {
      amount: 2000,
      detail: 'okodukai from boss'
    }

    post 'http://localhost:3000/api/v1/deposits', headers: @pos_tokens, params: param, as: :json
    assert_response :forbidden
  end

  test 'inventoryer create' do
    param = {
      amount: 2000,
      detail: 'okodukai from boss'
    }

    post 'http://localhost:3000/api/v1/deposits', headers: @inventoryer_tokens, params: param, as: :json
    assert_response :ok

    deposit = Deposit.last
    assert_equal deposit.amount, param[:amount]
  end

  test 'arriver create' do
    param = {
      amount: 2000,
      detail: 'okodukai from boss'
    }

    post 'http://localhost:3000/api/v1/deposits', headers: @arriver_tokens, params: param, as: :json
    assert_response :ok

    deposit = Deposit.last
    assert_equal deposit.amount, param[:amount]
  end
end
