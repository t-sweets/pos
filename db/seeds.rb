require 'bcrypt'

include BCrypt
# products
Product.create(name: "カップラーメン", price: 130, stock: 5, image_path: "https://3.bp.blogspot.com/-rZMHLcW6Er4/WlGpO69KN7I/AAAAAAABJlg/KgmrOkMSuoM0Xf0qRil3iOpMlGer-ypmACLcBGAs/s800/food_cup_ramen_miso.png")
Product.create(name: "アイス", price: 100, stock: 3, image_path: "https://2.bp.blogspot.com/-t7fJ99VE-HY/W64DlIeosgI/AAAAAAABPH8/fzyUKstvUT0mu7Aqt1em7Lms0ttprj_tQCLcBGAs/s800/icecream_cup_spoon_wood.png")

# payment method
PaymentMethod.create(name: "cash", addable: false, uuid: "1a0l2s9k3d")
PaymentMethod.create(name: "t-pay", addable: true, uuid: "4k4g96ld83")

# purchases
Purchase.create(payment_method_id: 1, payment_uuid: "2l3s0d9f45j")
Purchase.create(payment_method_id: 2, payment_uuid: "3l40g9fg493")

# purchase items
PurchaseItem.create(purchase_id: 1, quantity: 2, product_id: 1, price: 100)
PurchaseItem.create(purchase_id: 2, quantity: 1, product_id: 2, price: 100)

# admins
# Admin.create(name: "sharikae", password: "password")
Admin.create(name: "sharikae", email: "sharikae@example.com", password: "3lkjas0d98f34l3jk4t")
Admin.create(name: "ishiguro", email: "ishiguro@example.com", password: "3lkh4jg0dfkj345hl23")