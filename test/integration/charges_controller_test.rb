# frozen_string_literal: true

require 'test_helper'

class ChargesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_tokens = login(users(:admin))
    @pos_tokens = login(users(:pos))
    @inventoryer_tokens = login(users(:inventoryer))
    @arriver_tokens = login(users(:arriver))
  end

  # get index
  test 'admin create' do
    param = {
      payment_method_id: 2,
      amount: 2000
    }

    post 'http://localhost:3000/api/v1/charges', headers: @admin_tokens, params: param, as: :json
    assert_response :ok

    charge = Charge.last
    assert_equal charge.payment_method_id, param[:payment_method_id]
    assert_equal charge.amount, param[:amount]
  end

  test 'pos create' do
    param = {
      payment_method_id: 2,
      amount: 2000
    }

    post 'http://localhost:3000/api/v1/charges', headers: @pos_tokens, params: param, as: :json
    assert_response :ok

    charge = Charge.last
    assert_equal charge.payment_method_id, param[:payment_method_id]
    assert_equal charge.amount, param[:amount]
  end

  test 'inventoryer create' do
    param = {
      payment_method_id: 2,
      amount: 2000
    }

    post 'http://localhost:3000/api/v1/charges', headers: @inventoryer_tokens, params: param, as: :json
    assert_response :forbidden

    charge = Charge.last
    assert_equal charge.payment_method_id, param[:payment_method_id]
    assert_equal charge.amount, param[:amount]
  end

  test 'arriver create' do
    param = {
      payment_method_id: 2,
      amount: 2000
    }

    post 'http://localhost:3000/api/v1/charges', headers: @arriver_tokens, params: param, as: :json
    assert_response :forbidden
  end
end
