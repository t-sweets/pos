# frozen_string_literal: true

# products
Product.create(name: 'カップラーメン', price: 130, stock: 5, notification: true, notification_stock: 3, image_path: 'https://3.bp.blogspot.com/-rZMHLcW6Er4/WlGpO69KN7I/AAAAAAABJlg/KgmrOkMSuoM0Xf0qRil3iOpMlGer-ypmACLcBGAs/s800/food_cup_ramen_miso.png')
Product.create(name: 'アイス', price: 100, stock: 3, notification: false, image_path: 'https://2.bp.blogspot.com/-t7fJ99VE-HY/W64DlIeosgI/AAAAAAABPH8/fzyUKstvUT0mu7Aqt1em7Lms0ttprj_tQCLcBGAs/s800/icecream_cup_spoon_wood.png')

# payment method
PaymentMethod.create(name: 'cash', addable: false, uuid: '1a0l2s9k3d')
PaymentMethod.create(name: 't-pay', addable: true, uuid: '4k4g96ld83')

# purchases
Purchase.create(payment_method_id: 1, payment_uuid: '2l3s0d9f45j')
Purchase.create(payment_method_id: 2, payment_uuid: '3l40g9fg493')

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
