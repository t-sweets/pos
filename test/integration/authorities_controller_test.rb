# frozen_string_literal: true

require 'test_helper'

class AuthoritiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_tokens = login(users(:admin))
    @pos_tokens = login(users(:pos))
    @inventoryer_tokens = login(users(:inventoryer))
    @arriver_tokens = login(users(:arriver))
  end

  # get index
  test 'admin get index' do
    get 'http://localhost:3000/api/v1/authorities', headers: @admin_tokens
    assert_response :ok

    response = JSON.parse(@response.body)
    assert_equal 4, response.length
  end

  test 'pos get index' do
    get 'http://localhost:3000/api/v1/authorities', headers: @pos_tokens
    assert_response :ok

    response = JSON.parse(@response.body)
    assert_equal 4, response.length
  end

  test 'inventoryer get index' do
    get 'http://localhost:3000/api/v1/authorities', headers: @inventoryer_tokens
    assert_response :ok

    response = JSON.parse(@response.body)
    assert_equal 4, response.length
  end

  test 'arriver get index' do
    get 'http://localhost:3000/api/v1/authorities', headers: @arriver_tokens
    assert_response :ok

    response = JSON.parse(@response.body)
    assert_equal 4, response.length
  end
end
