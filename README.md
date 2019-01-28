# README

## toc
  * [api](#api)
    * auth
      * [sign in](#sign-in)
      * [sign up](#sign-up)
    * products
      * [products index](#products-index)
      * [products create](#products-create)
      * [products update](#products-update)
    * purchases
      * [purchase index](#purchase-index)
      * [purchase show](#purchase-show)
      * [purchase check](#purchase-check)
      * [purchase create](#purchase-create)
    * payment_methods
      * [payment_method index](#payment_method-index)
      * [payment_method create](#payment_method-create)
  * [how to build](#how-to-build)


## api

### sign in
  * endpoint: `base_url/api/v1/auth/sign_in`
  * method: POST
  * request body sample:
    ```json
    {
      "email": "ishiguro@example.com",
      "password": "3lkh4jg0dfkj345hl23"
    }
    ```
  * response body sample:
    * success
      ```json
      {
        "data": {
          "id": 2,
          "email": "ishiguro@example.com",
          "provider": "email",
          "uid": "ishiguro@example.com",
          "name": "ishiguro"
        }
      }
      ```
    * failure
      ```json
        {
          "success": false,
          "errors":[
            "Invalid login credentials. Please try again."
          ]
        }
      ```

### sign up
  * endpoint: `base_url/api/v1/auth`
  * method: POST
  * request body sample:
    ```json
    {
      "name": "ishigruo-test",
      "email": "ishiguro-test@example.com",
      "password": "password",
      "authority_id": 0
    }
    ```
  * response body sample:
    * success
      ```json
        {
          "status": "success",
          "data": {
            "id": 3,
            "provider": "email",
            "uid": "ishiguro-test@example.com",
            "name": "ishigruo-test",
            "email": "ishiguro-test@example.com",
            "authority_id": "admin",
            "created_at": "2019-01-28T20:12:36.000Z",
            "updated_at": "2019-01-28T20:12:36.000Z"
          }
        }
      ```

#### headers required for authentication
  * `access-token`
  * `client`
  * `uid`

### products index
  * endpoint: `base_url/api/v1/products`
  * method: GET
  * response body sample:
    ```json
    [
      {
        "id": 1,
        "name": "カップラーメン",
        "price": 130,
        "image_path": "https://3.bp.blogspot.com/-rZMHLcW6Er4/WlGpO69KN7I/AAAAAAABJlg/KgmrOkMSuoM0Xf0qRil3iOpMlGer-ypmACLcBGAs/s800/food_cup_ramen_miso.png",
        "cost": null,
        "stock": 5,
        "display": true,
        "created_at": "2019-01-25T16:59:24.000Z",
        "updated_at": "2019-01-25T16:59:24.000Z"
      },
      {
        "id": 2,
        "name": "アイス",
        "price": 100,
        "image_path": "https://2.bp.blogspot.com/-t7fJ99VE-HY/W64DlIeosgI/AAAAAAABPH8/fzyUKstvUT0mu7Aqt1em7Lms0ttprj_tQCLcBGAs/s800/icecream_cup_spoon_wood.png",
        "cost": null,
        "stock": 3,
        "display": true,
        "created_at": "2019-01-25T16:59:24.000Z",
        "updated_at": "2019-01-25T16:59:24.000Z"
      }
    ]
    ```

### products create
  * not implemented yet

### products update
  * endpoint: `base_url/api/v1/products/:id`
  * method: PUT
  * request body sample:
    ```json
    {
      "stock": 10,
      "display": false
    }
    ```
  * response body sample:
    * success
      ```json
      {
        "id": 1,
        "name": "カップラーメン",
        "price": 130,
        "stock": 10,
        "display": false,
        "cost": 100,
        "image_path": "https://3.bp.blogspot.com/-rZMHLcW6Er4/WlGpO69KN7I/AAAAAAABJlg/KgmrOkMSuoM0Xf0qRil3iOpMlGer-ypmACLcBGAs/s800/food_cup_ramen_miso.png",
        "created_at": "2019-01-25T16:59:24.000Z",
        "updated_at": "2019-01-25T17:08:57.000Z"
      }
      ```
    * failure


### purchase index
  * endpoint: `base_url/api/v1/purchases`
  * method: GET
  * response body sample:
    ```json
    [
      {
        "id": 1,
        "payment_method_id": 1,
        "payment_uuid": "2l3s0d9f45j",
        "created_at": "2019-01-25T16:59:24.000Z",
        "updated_at": "2019-01-25T16:59:24.000Z"
      },
      {
        "id": 2,
        "payment_method_id": 2,
        "payment_uuid": "3l40g9fg493",
        "created_at": "2019-01-25T16:59:24.000Z",
        "updated_at": "2019-01-25T16:59:24.000Z"
      },
      {
        "id": 3,
        "payment_method_id": 1,
        "payment_uuid": "hogefugapiyo1234",
        "created_at": "2019-01-25T17:15:22.000Z",
        "updated_at": "2019-01-25T17:15:22.000Z"
      }
    ]
    ```

### purchase show
  * endpoint: `base_url/api/v1/purchases/:id`
  * method: GET
  * response body sample:
    ```json
    {
      "id": 3,
      "payment_method_id": 1,
      "payment_uuid": "hogefugapiyo1234",
      "created_at": "2019-01-25T17:15:22.000Z",
      "updated_at": "2019-01-25T17:15:22.000Z",
      "purchase_items": [
        {
          "id": 3,
          "purchase_id": 3,
          "product_id": 1,
          "quantity": 2,
          "price": 100,
          "created_at": "2019-01-25T17:15:22.000Z",
          "updated_at": "2019-01-25T17:15:22.000Z"
        },
        {
          "id": 4,
          "purchase_id": 3,
          "product_id": 2,
          "quantity": 1,
          "price": 100,
          "created_at": "2019-01-25T17:15:22.000Z",
          "updated_at": "2019-01-25T17:15:22.000Z"
        }
      ],
      "products": [
        {
          "id": 1,
          "name": "カップラーメン",
          "price": 150,
          "image_path": "https://3.bp.blogspot.com/-rZMHLcW6Er4/WlGpO69KN7I/AAAAAAABJlg/KgmrOkMSuoM0Xf0qRil3iOpMlGer-ypmACLcBGAs/s800/food_cup_ramen_miso.png",
          "cost": 100,
          "stock": 8,
          "display": true,
          "created_at": "2019-01-25T16:59:24.000Z",
          "updated_at": "2019-01-25T17:15:22.000Z"
        },
        {
          "id": 2,
          "name": "アイス",
          "price": 100,
          "image_path": "https://2.bp.blogspot.com/-t7fJ99VE-HY/W64DlIeosgI/AAAAAAABPH8/fzyUKstvUT0mu7Aqt1em7Lms0ttprj_tQCLcBGAs/s800/icecream_cup_spoon_wood.png",
          "cost": null,
          "stock": 2,
          "display": true,
          "created_at": "2019-01-25T16:59:24.000Z",
          "updated_at": "2019-01-25T17:15:22.000Z"
        }
      ]
    }
    ```

### purchase check
  * endpoint: `base_url/api/v1/purchases/check`
  * method: POST
  * request body sample:
    ```json
    {
      "products": [
        {
          "product_id": 1,
          "price": 130
        },
        {
          "product_id": 2,
          "price": 100

        }
      ]
    }
    ```
  * response body sample:
    * not changed price
      ```json
      {
        "success": true,
        "products": [
          {
            "product_id": 1,
            "price": 130
          },
          {
            "product_id": 2,
            "price": 100
          }
        ]
      }
      ```
    * changed price
      ```json
      {
        "success": false,
        "errors":[
          "changed price."
        ]
      }
      ```

### purchase create
  * endpoint `base_url/api/v1/purchases`
  * method: POST
  * request body sample:
    ```json
    {
      "products": [
        {
          "product_id": 1,
          "quantity":2,
          "price": 100
        },
        {
          "product_id": 2,
          "quantity": 1,
          "price": 100

        }
      ],
      "payment_method": 1,
      "payment_uuid": "hogefugapiyo1234"
    }
    ```
  * response body sample:
      * success
        ```json
        {
          "success": true,
          "purchase": {
            "id": 3,
            "payment_method_id": 1,
            "payment_uuid": "hogefugapiyo1234",
            "created_at": "2019-01-28T20:25:37.000Z",
            "updated_at": "2019-01-28T20:25:37.000Z"
          }
        }
        ```
      * failure
        ```json
        ```

### payment_method index
  * endpoint: `base_url/api/v1/payment_methods`
  * method: GET
  * response body sample:
    ```json
    [
      {
        "id": 1,
        "name": "cash",
        "addable": "0",
        "uuid": "1a0l2s9k3d",
        "created_at": "2019-01-25T16:59:24.000Z",
        "updated_at": "2019-01-25T16:59:24.000Z"
      },
      {
        "id": 2,
        "name": "t-pay",
        "addable": "1",
        "uuid": "4k4g96ld83",
        "created_at": "2019-01-25T16:59:24.000Z",
        "updated_at": "2019-01-25T16:59:24.000Z"
      }
    ]
    ```

### payment_method create
  * not implemented yet

## how to build
  ```shell
    $ docker-compose build
    $ docker-compose run pos bundle exec rails db:drop db:create db:migrate db:seed
    $ docker-compose up
  ```