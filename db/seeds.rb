# frozen_string_literal: true

# products
Product.create(name: 'カップラーメン', price: 130, stock: 5, notification: true, notification_stock: 3, image_path: 'https://3.bp.blogspot.com/-rZMHLcW6Er4/WlGpO69KN7I/AAAAAAABJlg/KgmrOkMSuoM0Xf0qRil3iOpMlGer-ypmACLcBGAs/s800/food_cup_ramen_miso.png')
Product.create(name: 'アイス', price: 100, stock: 3, notification: false, image_path: 'https://2.bp.blogspot.com/-t7fJ99VE-HY/W64DlIeosgI/AAAAAAABPH8/fzyUKstvUT0mu7Aqt1em7Lms0ttprj_tQCLcBGAs/s800/icecream_cup_spoon_wood.png')

# payment method
PaymentMethod.create(name: 'cash', addable: false, uuid: 'F5EF99BC-0FF0-4CA4-805D-5045E12B90CF')
PaymentMethod.create(name: 't-pay', addable: true, uuid: '2ADEA824-0027-41B5-B243-10F2D24FDD4B')

# purchases
Purchase.create(payment_method_id: 1, payment_uuid: '0C6B213E-1517-4B94-8F50-43F3DD77DBB5')
Purchase.create(payment_method_id: 2, payment_uuid: 'FF6577A6-10E1-425D-B09A-3BA1B8BBCCD3')

# purchase items
PurchaseItem.create(purchase_id: 1, quantity: 2, product_id: 1, price: 100)
PurchaseItem.create(purchase_id: 2, quantity: 1, product_id: 2, price: 100)

# aurhorities
Authority.create(name: 'admin')
Authority.create(name: 'pos')
Authority.create(name: 'inventoryer')
Authority.create(name: 'arriver')

# users
User.create(name: 'sharikae', email: 'sharikae@example.com', password: '3lkjas0d98f34l3jk4t', authority_id: 1)
User.create(name: 'yamashita', email: 'sho@example.com', password: '3lkh4jg0dfkj345hl23', authority_id: 2)
User.create(name: 'kochi', email: 'kochi@example.com', password: '3lkh4jg0dfkj345hl23', authority_id: 3)
User.create(name: 'ishiguro', email: 'ishiguro@example.com', password: '3lkh4jg0dfkj345hl23', authority_id: 4)

# charges
Charge.create(payment_method_id: 2, amount: 1000)
Charge.create(payment_method_id: 2, amount: 2000)

# withdraws
Withdraw.create(amount: 500)

# balance
Balance.create(amount: 0, sales: 0, card_added: 0)

# audit logs
AuditLog.create(model: 'product', model_id: 1, operation: 'create', operator: 1, detail: 'this model created by seeder.')
AuditLog.create(model: 'product', model_id: 2, operation: 'create', operator: 1, detail: 'this model created by seeder.')
AuditLog.create(model: 'purchase', model_id: 1, operation: 'create', operator: 2, detail: 'this model created by seeder.')
AuditLog.create(model: 'purchase', model_id: 2, operation: 'create', operator: 2, detail: 'this model created by seeder.')
AuditLog.create(model: 'user', model_id: 2, operation: 'create', operator: 1, detail: 'this model created by seeder.')
AuditLog.create(model: 'user', model_id: 3, operation: 'create', operator: 1, detail: 'this model created by seeder.')
AuditLog.create(model: 'user', model_id: 4, operation: 'create', operator: 1, detail: 'this model created by seeder.')
