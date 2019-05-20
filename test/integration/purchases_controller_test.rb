# frozen_string_literal: true

require 'test_helper'

class PurchasesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_tokens = login(users(:admin))
    @pos_tokens = login(users(:pos))
    @inventoryer_tokens = login(users(:inventoryer))
    @arriver_tokens = login(users(:arriver))
  end

  # get index
  test 'admin get index' do
    get 'http://localhost:3000/api/v1/purchases', headers: @admin_tokens
    assert_response :ok
  end

  test 'pos get index' do
    get 'http://localhost:3000/api/v1/purchases', headers: @pos_tokens
    assert_response :ok
  end

  test 'inventoryer get index' do
    get 'http://localhost:3000/api/v1/purchases', headers: @inventoryer_tokens
    assert_response :forbidden
  end

  test 'arriver get index' do
    get 'http://localhost:3000/api/v1/purchases', headers: @arriver_tokens
    assert_response :forbidden
  end

  # get active index
  test 'admin get active index' do
    get 'http://localhost:3000/api/v1/purchases/actives', headers: @admin_tokens
    assert_response :ok
  end

  test 'pos get active index' do
    get 'http://localhost:3000/api/v1/purchases/actives', headers: @pos_tokens
    assert_response :ok
  end

  test 'inventoryer get active index' do
    get 'http://localhost:3000/api/v1/purchases/actives', headers: @inventoryer_tokens
    assert_response :forbidden
  end

  test 'arriver get active index' do
    get 'http://localhost:3000/api/v1/purchases/actives', headers: @arriver_tokens
    assert_response :forbidden
  end

  # create
  test 'admin create' do
    new_purchase = {
      products: [
        {
          product_id: 1,
          quantity: 2,
          price: 100
        },
        {
          product_id: 2,
          quantity: 1,
          price: 100
        }
      ],
      payment_method_id: 1,
      payment_uuid: '0C6B213E-1517-4B94-8F50-43F3DD77DBB5'
    }

    post 'http://localhost:3000/api/v1/purchases', headers: @admin_tokens, params: new_purchase, as: :json
    assert_response :created

    purchase = Purchase.last
    assert_equal new_purchase[:payment_method_id], purchase.payment_method_id
    assert_equal new_purchase[:payment_uuid], purchase.payment_uuid

    purchase_items = PurchaseItem.where(purchase_id: purchase.id).order(:created_at)
    purchase_items.each_with_index do |item, index|
      assert_equal new_purchase[:products][index][:product_id], item.product_id
      assert_equal new_purchase[:products][index][:quantity], item.quantity
      assert_equal new_purchase[:products][index][:price], item.price
    end
  end

  test 'pos create' do
    new_purchase = {
      products: [
        {
          product_id: 1,
          quantity: 2,
          price: 100
        },
        {
          product_id: 2,
          quantity: 1,
          price: 100
        }
      ],
      payment_method_id: 1,
      payment_uuid: '0C6B213E-1517-4B94-8F50-43F3DD77DBB5'
    }

    post 'http://localhost:3000/api/v1/purchases', headers: @pos_tokens, params: new_purchase, as: :json
    assert_response :created

    purchase = Purchase.last
    assert_equal new_purchase[:payment_method_id], purchase.payment_method_id
    assert_equal new_purchase[:payment_uuid], purchase.payment_uuid

    purchase_items = PurchaseItem.where(purchase_id: purchase.id).order(:created_at)
    purchase_items.each_with_index do |item, index|
      assert_equal new_purchase[:products][index][:product_id], item.product_id
      assert_equal new_purchase[:products][index][:quantity], item.quantity
      assert_equal new_purchase[:products][index][:price], item.price
    end
  end

  test 'inventoryer create' do
    new_purchase = {
      products: [
        {
          product_id: 1,
          quantity: 2,
          price: 100
        },
        {
          product_id: 2,
          quantity: 1,
          price: 100
        }
      ],
      payment_method_id: 1,
      payment_uuid: '0C6B213E-1517-4B94-8F50-43F3DD77DBB5'
    }

    post 'http://localhost:3000/api/v1/purchases', headers: @inventoryer_tokens, params: new_purchase, as: :json
    assert_response :forbidden
  end

  test 'arriver create' do
    new_purchase = {
      products: [
        {
          product_id: 1,
          quantity: 2,
          price: 100
        },
        {
          product_id: 2,
          quantity: 1,
          price: 100
        }
      ],
      payment_method_id: 1,
      payment_uuid: '0C6B213E-1517-4B94-8F50-43F3DD77DBB5'
    }

    post 'http://localhost:3000/api/v1/purchases', headers: @arriver_tokens, params: new_purchase, as: :json
    assert_response :forbidden
  end

  # check
  test 'admin check' do
    param = {
      products: [
        {
          product_id: 1,
          price: 100
        },
        {
          product_id: 2,
          price: 100
        }
      ]
    }

    post 'http://localhost:3000/api/v1/purchases/check', headers: @admin_tokens, params: param, as: :json
    assert_response :ok

    assert_equal true, JSON.parse(@response.body)['success']
  end

  test 'admin check invalid' do
    param = {
      products: [
        {
          product_id: 1,
          price: 130
        },
        {
          product_id: 2,
          price: 130
        }
      ]
    }

    post 'http://localhost:3000/api/v1/purchases/check', headers: @admin_tokens, params: param, as: :json
    assert_response :ok

    assert_equal false, JSON.parse(@response.body)['success']
  end

  test 'pos check' do
    param = {
      products: [
        {
          product_id: 1,
          price: 100
        },
        {
          product_id: 2,
          price: 100
        }
      ]
    }

    post 'http://localhost:3000/api/v1/purchases/check', headers: @pos_tokens, params: param, as: :json
    assert_response :ok

    assert_equal true, JSON.parse(@response.body)['success']
  end

  test 'pos check invalid' do
    param = {
      products: [
        {
          product_id: 1,
          price: 130
        },
        {
          product_id: 2,
          price: 130
        }
      ]
    }

    post 'http://localhost:3000/api/v1/purchases/check', headers: @pos_tokens, params: param, as: :json
    assert_response :ok

    assert_equal false, JSON.parse(@response.body)['success']
  end

  test 'inventoryer check' do
    param = {
      products: [
        {
          product_id: 1,
          price: 100
        },
        {
          product_id: 2,
          price: 100
        }
      ]
    }

    post 'http://localhost:3000/api/v1/purchases/check', headers: @inventoryer_tokens, params: param, as: :json
    assert_response :forbidden
  end

  test 'arriver check' do
    param = {
      products: [
        {
          product_id: 1,
          price: 100
        },
        {
          product_id: 2,
          price: 100
        }
      ]
    }

    post 'http://localhost:3000/api/v1/purchases/check', headers: @arriver_tokens, params: param, as: :json
    assert_response :forbidden
  end

  # destroy
  test 'admin destroy' do
    id = Purchase.last.id

    delete "http://localhost:3000/api/v1/purchases/#{id}", headers: @admin_tokens
    assert_response :no_content

    purchase = Purchase.find(id)
    assert_equal true, purchase.deleted
  end

  test 'pos destroy' do
    id = Purchase.last.id

    delete "http://localhost:3000/api/v1/purchases/#{id}", headers: @pos_tokens
    assert_response :forbidden
  end

  test 'inventoryer destroy' do
    id = Purchase.last.id

    delete "http://localhost:3000/api/v1/purchases/#{id}", headers: @inventoryer_tokens
    assert_response :no_content

    purchase = Purchase.find(id)
    assert_equal true, purchase.deleted
  end

  test 'arriver destroy' do
    id = Purchase.last.id

    delete "http://localhost:3000/api/v1/purchases/#{id}", headers: @arriver_tokens
    assert_response :forbidden
  end
end
