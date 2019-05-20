# frozen_string_literal: true

require 'test_helper'

class PaymentMethodsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_tokens = login(users(:admin))
    @pos_tokens = login(users(:pos))
    @inventoryer_tokens = login(users(:inventoryer))
    @arriver_tokens = login(users(:arriver))
  end

  # get index
  test 'admin get index' do
    get 'http://localhost:3000/api/v1/payment_methods', headers: @admin_tokens
    assert_response :ok

    assert_equal 2, JSON.parse(@response.body).length
  end

  test 'pos get index' do
    get 'http://localhost:3000/api/v1/payment_methods', headers: @pos_tokens
    assert_response :ok

    assert_equal 2, JSON.parse(@response.body).length
  end

  test 'inventoryer get index' do
    get 'http://localhost:3000/api/v1/payment_methods', headers: @inventoryer_tokens
    assert_response :ok

    assert_equal 2, JSON.parse(@response.body).length
  end

  test 'arriver get index' do
    get 'http://localhost:3000/api/v1/payment_methods', headers: @arriver_tokens
    assert_response :ok

    assert_equal 2, JSON.parse(@response.body).length
  end
end
