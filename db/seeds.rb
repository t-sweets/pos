# frozen_string_literal: true

# products
Product.create(name: 'カップラーメン', price: 130, stock: 5, notification: true, notification_stock: 3, image_uuid: '8d1f7602-588f-4deb-8a41-ce53a34826ed', image_path: '/product_images/8d1f7602-588f-4deb-8a41-ce53a34826ed.png', jan: '4971633002791')
Product.create(name: 'アイス', price: 100, stock: 3, display: false, notification: false, image_uuid: 'd572ab82-62e6-4ca5-b1a4-fcde2fc0c9c7', image_path: '/product_images/d572ab82-62e6-4ca5-b1a4-fcde2fc0c9c7.png', jan: '4902105003374')

# payment method
PaymentMethod.create(name: 'cash', addable: false, uuid: 'F5EF99BC-0FF0-4CA4-805D-5045E12B90CF')
PaymentMethod.create(name: 't-pay', addable: true, uuid: '2ADEA824-0027-41B5-B243-10F2D24FDD4B')

# purchases
Purchase.create(payment_method_id: 1, payment_uuid: '0C6B213E-1517-4B94-8F50-43F3DD77DBB5') # 1
Purchase.create(payment_method_id: 2, payment_uuid: 'FF6577A6-10E1-425D-B09A-3BA1B8BBCCD3') # 2

# purchase items
PurchaseItem.create(purchase_id: 1, quantity: 2, product_id: 1, price: 100)
PurchaseItem.create(purchase_id: 2, quantity: 1, product_id: 2, price: 100)

# test purchases
p = Purchase.create(payment_method_id: 1, payment_uuid: '0C6B213E-1517-4B94-8F50-43F3DD77DBB5', created_at: DateTime.new(2019, 3, 3.5))
PurchaseItem.create(purchase_id: p.id, quantity: 3, product_id: 1, price: 100, created_at: p.created_at)
PurchaseItem.create(purchase_id: p.id, quantity: 3, product_id: 2, price: 100, created_at: p.created_at)

p = Purchase.create(payment_method_id: 1, payment_uuid: '0C6B213E-1517-4B94-8F50-43F3DD77DBB5', created_at: DateTime.new(2019, 3, 5.5))
PurchaseItem.create(purchase_id: p.id, quantity: 10, product_id: 1, price: 100, created_at: p.created_at)

p = Purchase.create(payment_method_id: 1, payment_uuid: '0C6B213E-1517-4B94-8F50-43F3DD77DBB5', created_at: DateTime.new(2018, 2, 3.5))
PurchaseItem.create(purchase_id: p.id, quantity: 3, product_id: 1, price: 100, created_at: p.created_at)

p = Purchase.create(payment_method_id: 1, payment_uuid: '0C6B213E-1517-4B94-8F50-43F3DD77DBB5', created_at: DateTime.new(2018, 6, 3.5))
PurchaseItem.create(purchase_id: p.id, quantity: 7, product_id: 2, price: 100, created_at: p.created_at)

p = Purchase.create(payment_method_id: 1, payment_uuid: '0C6B213E-1517-4B94-8F50-43F3DD77DBB5', created_at: DateTime.new(2018, 3, 3.5))
PurchaseItem.create(purchase_id: p.id, quantity: 6, product_id: 1, price: 100, created_at: p.created_at)
PurchaseItem.create(purchase_id: p.id, quantity: 2, product_id: 2, price: 100, created_at: p.created_at)

p = Purchase.create(payment_method_id: 1, payment_uuid: '0C6B213E-1517-4B94-8F50-43F3DD77DBB5', created_at: DateTime.new(2010, 3, 3.5))
PurchaseItem.create(purchase_id: p.id, quantity: 2, product_id: 1, price: 100, created_at: DateTime.new(2010, 3, 3.5))
PurchaseItem.create(purchase_id: p.id, quantity: 4, product_id: 2, price: 100, created_at: DateTime.new(2010, 3, 3.5))

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
