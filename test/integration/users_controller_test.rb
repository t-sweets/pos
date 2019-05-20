# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_tokens = login(users(:admin))
    @pos_tokens = login(users(:pos))
    @inventoryer_tokens = login(users(:inventoryer))
    @arriver_tokens = login(users(:arriver))
  end

  # get index
  test 'admin get index' do
    get 'http://localhost:3000/api/v1/users', headers: @admin_tokens
    assert_response :ok

    response = JSON.parse(@response.body)
    assert_equal 5, response.length
  end

  test 'pos get index' do
    get 'http://localhost:3000/api/v1/users', headers: @pos_tokens
    assert_response :forbidden
  end

  test 'inventoryer get index' do
    get 'http://localhost:3000/api/v1/users', headers: @inventoryer_tokens
    assert_response :forbidden
  end

  test 'arriver get index' do
    get 'http://localhost:3000/api/v1/users', headers: @arriver_tokens
    assert_response :forbidden
  end

  # get active index
  test 'admin get active index' do
    get 'http://localhost:3000/api/v1/users/actives', headers: @admin_tokens
    assert_response :ok

    response = JSON.parse(@response.body)
    assert_equal 4, response.length
  end

  test 'pos get active index' do
    get 'http://localhost:3000/api/v1/users/actives', headers: @pos_tokens
    assert_response :forbidden
  end

  test 'inventoryer get active index' do
    get 'http://localhost:3000/api/v1/users/actives', headers: @inventoryer_tokens
    assert_response :forbidden
  end

  test 'arriver get active index' do
    get 'http://localhost:3000/api/v1/users/actives', headers: @arriver_tokens
    assert_response :forbidden
  end

  # update
  # test 'admin update self' do
  #   put 'http://localhost:3000/api/v1/users', headers: @admin_tokens, params: { name: 'admin_updated' }, as: :json
  #   assert_response :success
  # end
  #
  # test 'pos update self' do
  #   put 'http://localhost:3000/api/v1/users', headers: @pos_tokens, params: { name: 'pos_updated' }, as: :json
  #   assert_response :success
  # end
  #
  # test 'pos update self' do
  #   put 'http://localhost:3000/api/v1/users', headers: @pos_tokens, params: { name: 'pos_updated' }, as: :json
  #   assert_response :success
  # end
  #
  # test 'pos update self' do
  #   put 'http://localhost:3000/api/v1/users', headers: @pos_tokens, params: { name: 'pos_updated' }, as: :json
  #   assert_response :success
  # end
end
