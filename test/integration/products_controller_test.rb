# frozen_string_literal: true

require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_tokens = login(users(:admin))
    @pos_tokens = login(users(:pos))
    @inventoryer_tokens = login(users(:inventoryer))
    @arriver_tokens = login(users(:arriver))
  end

  # get index
  test 'admin get index' do
    get 'http://localhost:3000/api/v1/products', headers: @admin_tokens
    assert_response :ok

    response = JSON.parse(@response.body)
    assert_equal 2, response.length
  end

  test 'pos get index' do
    get 'http://localhost:3000/api/v1/products', headers: @pos_tokens
    assert_response :ok

    response = JSON.parse(@response.body)
    assert_equal 2, response.length
  end

  test 'inventoryer get index' do
    get 'http://localhost:3000/api/v1/products', headers: @inventoryer_tokens
    assert_response :ok

    response = JSON.parse(@response.body)
    assert_equal 2, response.length
  end

  test 'arriver get index' do
    get 'http://localhost:3000/api/v1/products', headers: @arriver_tokens
    assert_response :ok

    response = JSON.parse(@response.body)
    assert_equal 2, response.length
  end

  # get active index
  test 'admin get active index' do
    get 'http://localhost:3000/api/v1/products/actives', headers: @admin_tokens
    assert_response :ok

    response = JSON.parse(@response.body)
    assert_equal 1, response.length
  end

  test 'pos get active index' do
    get 'http://localhost:3000/api/v1/products/actives', headers: @pos_tokens
    response = JSON.parse(@response.body)
    assert_equal 1, response.length
  end

  test 'inventoryer get active index' do
    get 'http://localhost:3000/api/v1/products/actives', headers: @inventoryer_tokens
    response = JSON.parse(@response.body)
    assert_equal 1, response.length
  end

  test 'arriver get active index' do
    get 'http://localhost:3000/api/v1/products/actives', headers: @arriver_tokens
    response = JSON.parse(@response.body)
    assert_equal 1, response.length
  end

  # create
  test 'admin create' do
    new_product = {
      name: 'admin_create',
      price: 130,
      stock: 10,
      display: true,
      cost: 100,
      notification: true,
      notification_stock: 3,
      image: 'https://3.bp.blogspot.com/-I5omlyOiw04/W1vg2o3hHgI/AAAAAAABNr4/_PpEM8ZROX42aTaNNZQK2_p2JT7Bfp8zgCLcBGAs/s400/animal_chara_computer_neko.png',
      jan: 'janjan'
    }

    post 'http://localhost:3000/api/v1/products', headers: @admin_tokens, params: new_product, as: :json
    assert_response :created

    product = Product.last
    assert_equal new_product[:name], product.name
    assert_equal new_product[:price], product.price
    assert_equal new_product[:stock], product.stock
    assert_equal new_product[:display], product.display
    assert_equal new_product[:cost], product.cost
    assert_equal new_product[:notification], product.notification
    assert_equal new_product[:notification_stock], product.notification_stock
    assert_equal new_product[:image], product.image_path
    assert_equal new_product[:jan], product.jan
  end

  test 'pos create' do
    new_product = {
      name: 'pos_create',
      price: 130,
      stock: 10,
      display: true,
      cost: 100,
      notification: true,
      notification_stock: 3,
      image: 'https://3.bp.blogspot.com/-I5omlyOiw04/W1vg2o3hHgI/AAAAAAABNr4/_PpEM8ZROX42aTaNNZQK2_p2JT7Bfp8zgCLcBGAs/s400/animal_chara_computer_neko.png',
      jan: 'janjan'
    }

    post 'http://localhost:3000/api/v1/products', headers: @pos_tokens, params: new_product, as: :json
    assert_response :forbidden
  end

  test 'inventoryer create' do
    new_product = {
      name: 'inventoryer_create',
      price: 130,
      stock: 10,
      display: true,
      cost: 100,
      notification: true,
      notification_stock: 3,
      image: 'https://3.bp.blogspot.com/-I5omlyOiw04/W1vg2o3hHgI/AAAAAAABNr4/_PpEM8ZROX42aTaNNZQK2_p2JT7Bfp8zgCLcBGAs/s400/animal_chara_computer_neko.png',
      jan: 'janjan'
    }

    post 'http://localhost:3000/api/v1/products', headers: @inventoryer_tokens, params: new_product, as: :json
    assert_response :created

    product = Product.last
    assert_equal new_product[:name], product.name
    assert_equal new_product[:price], product.price
    assert_equal new_product[:stock], product.stock
    assert_equal new_product[:display], product.display
    assert_equal new_product[:cost], product.cost
    assert_equal new_product[:notification], product.notification
    assert_equal new_product[:notification_stock], product.notification_stock
    assert_equal new_product[:image], product.image_path
    assert_equal new_product[:jan], product.jan
  end

  test 'arriver create' do
    new_product = {
      name: 'arriver_create',
      price: 130,
      stock: 10,
      display: true,
      cost: 100,
      notification: true,
      notification_stock: 3,
      image: 'https://3.bp.blogspot.com/-I5omlyOiw04/W1vg2o3hHgI/AAAAAAABNr4/_PpEM8ZROX42aTaNNZQK2_p2JT7Bfp8zgCLcBGAs/s400/animal_chara_computer_neko.png',
      jan: 'janjan'
    }

    post 'http://localhost:3000/api/v1/products', headers: @arriver_tokens, params: new_product, as: :json
    assert_response :created

    product = Product.last
    assert_equal new_product[:name], product.name
    assert_equal new_product[:price], product.price
    assert_equal new_product[:stock], product.stock
    assert_equal new_product[:display], product.display
    assert_equal new_product[:cost], product.cost
    assert_equal new_product[:notification], product.notification
    assert_equal new_product[:notification_stock], product.notification_stock
    assert_equal new_product[:image], product.image_path
    assert_equal new_product[:jan], product.jan
  end

  # update
  test 'admin update' do
    update_param = {
      name: 'admin_update',
      price: 100,
      stock: 5,
      display: false,
      cost: 80,
      notification: false,
      notification_stock: 5,
      image: 'https://3.bp.blogspot.com/-IzBBa1iaxGc/XLQNJ_ysffI/AAAAAAABSbw/hgX31eDYY6QX5btrmZTNuMDm9JQL8B1ygCLcBGAs/s400/uchidenokoduchi_eto13_neko.png',
      jan: 'janjanjan'
    }

    put "http://localhost:3000/api/v1/products/#{rand(1..Product.all.count)}", headers: @admin_tokens, params: update_param, as: :json
    assert_response :ok

    product = Product.all.order(updated_at: 'DESC').first
    assert_equal update_param[:name], product.name
    assert_equal update_param[:price], product.price
    assert_equal update_param[:stock], product.stock
    assert_equal update_param[:display], product.display
    assert_equal update_param[:cost], product.cost
    assert_equal update_param[:notification], product.notification
    assert_equal update_param[:notification_stock], product.notification_stock
    assert_equal update_param[:image], product.image_path
    assert_equal update_param[:jan], product.jan
  end

  test 'pos update' do
    update_param = {
      name: 'pos_update',
      price: 100,
      stock: 5,
      display: false,
      cost: 80,
      notification: false,
      notification_stock: 5,
      image: 'https://3.bp.blogspot.com/-IzBBa1iaxGc/XLQNJ_ysffI/AAAAAAABSbw/hgX31eDYY6QX5btrmZTNuMDm9JQL8B1ygCLcBGAs/s400/uchidenokoduchi_eto13_neko.png',
      jan: 'janjanjan'
    }

    put "http://localhost:3000/api/v1/products/#{rand(1..Product.all.count)}", headers: @pos_tokens, params: update_param, as: :json
    assert_response :forbidden
  end

  test 'inventoryer update' do
    update_param = {
      name: 'inventoryer_update',
      price: 100,
      stock: 5,
      display: false,
      cost: 80,
      notification: false,
      notification_stock: 5,
      image: 'https://3.bp.blogspot.com/-IzBBa1iaxGc/XLQNJ_ysffI/AAAAAAABSbw/hgX31eDYY6QX5btrmZTNuMDm9JQL8B1ygCLcBGAs/s400/uchidenokoduchi_eto13_neko.png',
      jan: 'janjanjan'
    }

    put "http://localhost:3000/api/v1/products/#{rand(1..Product.all.count)}", headers: @admin_tokens, params: update_param, as: :json
    assert_response :ok

    product = Product.all.order(updated_at: 'DESC').first
    assert_equal update_param[:name], product.name
    assert_equal update_param[:price], product.price
    assert_equal update_param[:stock], product.stock
    assert_equal update_param[:display], product.display
    assert_equal update_param[:cost], product.cost
    assert_equal update_param[:notification], product.notification
    assert_equal update_param[:notification_stock], product.notification_stock
    assert_equal update_param[:image], product.image_path
    assert_equal update_param[:jan], product.jan
  end

  test 'arriver update' do
    update_param = {
      name: 'arriver_update',
      price: 100,
      stock: 5,
      display: false,
      cost: 80,
      notification: false,
      notification_stock: 5,
      image: 'https://3.bp.blogspot.com/-IzBBa1iaxGc/XLQNJ_ysffI/AAAAAAABSbw/hgX31eDYY6QX5btrmZTNuMDm9JQL8B1ygCLcBGAs/s400/uchidenokoduchi_eto13_neko.png',
      jan: 'janjanjan'
    }

    put "http://localhost:3000/api/v1/products/#{rand(1..Product.all.count)}", headers: @arriver_tokens, params: update_param, as: :json
    assert_response :forbidden
  end

  # destroy

  # TODO: なんでかわからないけど、削除できないわー
  # test 'admin destroy' do
  #   id = Product.last.id
  #
  #   delete "http://localhost:3000/api/v1/products/#{id}", headers: @admin_tokens
  #   assert_response :no_content
  #   assert_nil Product.find(id)
  # end

  test 'pos destroy' do
    id = Product.last.id

    delete "http://localhost:3000/api/v1/products/#{id}", headers: @pos_tokens
    assert_response :forbidden
  end

  # TODO: なんでかわからないけど、削除できないわー
  # test 'inventoryer destroy' do
  #   id = Product.last.id
  #
  #   delete "http://localhost:3000/api/v1/products/#{id}", headers: @inventoryer_tokens
  #   assert_response :no_content
  #   assert_nil Product.find(id)
  # end

  test 'arriver destroy' do
    id = Product.last.id

    delete "http://localhost:3000/api/v1/products/#{id}", headers: @arriver_tokens
    assert_response :forbidden
  end

  # add_stock
  test 'admin add stock' do
    product = Product.last
    add_stock_param = { additional_quantity: 10 }

    post "http://localhost:3000/api/v1/products/#{product.id}/stock", headers: @admin_tokens, params: add_stock_param, as: :json
    assert_response :ok

    assert_equal product.stock + add_stock_param[:additional_quantity], Product.find(product.id).stock
  end

  test 'pos add stock' do
    product = Product.last
    add_stock_param = { additional_quantity: 10 }

    post "http://localhost:3000/api/v1/products/#{product.id}/stock", headers: @pos_tokens, params: add_stock_param, as: :json
    assert_response :forbidden
  end

  test 'inventoryer add stock' do
    product = Product.last
    add_stock_param = { additional_quantity: 10 }

    post "http://localhost:3000/api/v1/products/#{product.id}/stock", headers: @inventoryer_tokens, params: add_stock_param, as: :json
    assert_response :ok

    assert_equal product.stock + add_stock_param[:additional_quantity], Product.find(product.id).stock
  end

  test 'arriver add stock' do
    product = Product.last
    add_stock_param = { additional_quantity: 10 }

    post "http://localhost:3000/api/v1/products/#{product.id}/stock", headers: @arriver_tokens, params: add_stock_param, as: :json
    assert_response :ok

    assert_equal product.stock + add_stock_param[:additional_quantity], Product.find(product.id).stock
  end

  # increase_price
  test 'admin increase price' do
    product = Product.last
    increase_price_param = { additional_quantity: 30 }

    post "http://localhost:3000/api/v1/products/#{product.id}/price", headers: @admin_tokens, params: increase_price_param, as: :json
    assert_response :ok

    assert_equal product.price + increase_price_param[:additional_quantity], Product.find(product.id).price
  end

  test 'pos increase price' do
    product = Product.last
    increase_price_param = { additional_quantity: 30 }

    post "http://localhost:3000/api/v1/products/#{product.id}/price", headers: @pos_tokens, params: increase_price_param, as: :json
    assert_response :forbidden
  end

  test 'inventoryer increase price' do
    product = Product.last
    increase_price_param = { additional_quantity: 30 }

    post "http://localhost:3000/api/v1/products/#{product.id}/price", headers: @inventoryer_tokens, params: increase_price_param, as: :json
    assert_response :ok

    assert_equal product.price + increase_price_param[:additional_quantity], Product.find(product.id).price
  end

  test 'arriver increase price' do
    product = Product.last
    increase_price_param = { additional_quantity: 30 }

    post "http://localhost:3000/api/v1/products/#{product.id}/price", headers: @arriver_tokens, params: increase_price_param, as: :json
    assert_response :ok

    assert_equal product.price + increase_price_param[:additional_quantity], Product.find(product.id).price
  end

  # arrival
  test 'admin arrival' do
    last_product = Product.last
    param = {
      price_additional_quantity: 10,
      stock_additional_quantity: 10,
      cost: 70
    }

    post "http://localhost:3000/api/v1/products/#{last_product.id}/arrival", headers: @admin_tokens, params: param, as: :json
    assert_response :ok

    product = Product.find(last_product.id)
    assert_equal last_product.price + param[:price_additional_quantity], product.price
    assert_equal last_product.stock + param[:stock_additional_quantity], product.stock
    assert_equal param[:cost], product.cost
  end

  test 'pos arrival' do
    last_product = Product.last
    param = {
      price_additional_quantity: 10,
      stock_additional_quantity: 10,
      cost: 70
    }

    post "http://localhost:3000/api/v1/products/#{last_product.id}/arrival", headers: @pos_tokens, params: param, as: :json
    assert_response :forbidden
  end

  test 'inventoryer arrival' do
    last_product = Product.last
    param = {
      price_additional_quantity: 10,
      stock_additional_quantity: 10,
      cost: 70
    }

    post "http://localhost:3000/api/v1/products/#{last_product.id}/arrival", headers: @inventoryer_tokens, params: param, as: :json
    assert_response :ok

    product = Product.find(last_product.id)
    assert_equal last_product.price + param[:price_additional_quantity], product.price
    assert_equal last_product.stock + param[:stock_additional_quantity], product.stock
    assert_equal param[:cost], product.cost
  end

  test 'arriver arrival' do
    last_product = Product.last
    param = {
      price_additional_quantity: 10,
      stock_additional_quantity: 10,
      cost: 70
    }

    post "http://localhost:3000/api/v1/products/#{last_product.id}/arrival", headers: @arriver_tokens, params: param, as: :json
    assert_response :ok

    product = Product.find(last_product.id)
    assert_equal last_product.price + param[:price_additional_quantity], product.price
    assert_equal last_product.stock + param[:stock_additional_quantity], product.stock
    assert_equal param[:cost], product.cost
  end
end
