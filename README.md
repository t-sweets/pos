# README

## toc
  * [api](##api)
    * auth
      * [sign in](###sign-in)
    * products
      * [products index](###products-index)
      * [products create](###products-create)
    * purchases
      * [purchase index](###purchase-index)
      * [purchase check](###purchase-check)
      * [purchase create](###purchase-create)
    * payment_methods
      * [payment_method index](###payment_method-index)
      * [payment_method create](###payment_method-create)


## api

### sign in
  * endpoint: `base_url/api/v1/auth/sign_in`
  * POST
  * body sample:
```
{
  "email": "ishiguro@example.com",
  "password": "3lkh4jg0dfkj345hl23"
}
```

#### headers required for authentication
  * access-token
  * client
  * uid

### products index
  * endpoint: `base_url/api/v1/products`
  * method: GET

### products create
  * not implement yet

### purchase index
  * endpoint: `base_url/api/v1/purchases`
  * method: GET

### purchase check
  * endpoint: `base_url/api/v1/purchases/check`
  * method: POST
  * body sample
```
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

### purchase create
  * endpoint `base_url/api/v1//purchases`
  * method: POST
  * body sample
```
{
  "products": [
    {
      "quantity":2,
      "purchase_id": 1,
      "price": 100
    },
    {
      "quantity": 1,
      "purchase_id": 2,
      "price": 100

    }
  ],
  "payment_method": 1,
  "payment_uuid": "hogefugapiyo1234"
}
```

### payment_method index
  * endpoint: `base_url/api/v1/payment_methods`
  * method: GET

### payment_method create
  * not implement yet
