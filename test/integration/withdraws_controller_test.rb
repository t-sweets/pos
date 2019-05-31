# frozen_string_literal: true

require 'test_helper'

class WithdrawsControllerTest < ActionDispatch::IntegrationTest
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
      detail: 'for arrival at 2019/04/18 sanwa shop'
    }

    post 'http://localhost:3000/api/v1/withdraws', headers: @admin_tokens, params: param, as: :json
    assert_response :ok

    withdraw = Withdraw.last
    assert_equal withdraw.amount, param[:amount]
  end

  test 'pos create' do
    param = {
      amount: 2000,
      detail: 'for arrival at 2019/04/18 sanwa shop'
    }

    post 'http://localhost:3000/api/v1/withdraws', headers: @pos_tokens, params: param, as: :json
    assert_response :forbidden
  end

  test 'inventoryer create' do
    param = {
      amount: 2000,
      detail: 'for arrival at 2019/04/18 sanwa shop'
    }

    post 'http://localhost:3000/api/v1/withdraws', headers: @inventoryer_tokens, params: param, as: :json
    assert_response :ok

    withdraw = Withdraw.last
    assert_equal withdraw.amount, param[:amount]
  end

  test 'arriver create' do
    param = {
      amount: 2000,
      detail: 'for arrival at 2019/04/18 sanwa shop'
    }

    post 'http://localhost:3000/api/v1/withdraws', headers: @arriver_tokens, params: param, as: :json
    assert_response :ok

    withdraw = Withdraw.last
    assert_equal withdraw.amount, param[:amount]
  end
end
