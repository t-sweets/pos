# frozen_string_literal: true

# payment method
PaymentMethod.create(name: 'cash', addable: false, uuid: 'F5EF99BC-0FF0-4CA4-805D-5045E12B90CF')
PaymentMethod.create(name: 't-pay', addable: true, uuid: '2ADEA824-0027-41B5-B243-10F2D24FDD4B')

# aurhorities
Authority.create(name: 'admin')
Authority.create(name: 'pos')
Authority.create(name: 'inventoryer')
Authority.create(name: 'arriver')

# users
User.create(name: 'sharikae', email: 'sharikae@example.com', password: 'initialpassword', authority_id: 1)
User.create(name: 'yamashita', email: 'sho@example.com', password: 'initialpassword', authority_id: 2)
User.create(name: 'kochi', email: 'kochi@example.com', password: 'initialpassword', authority_id: 3)
User.create(name: 'ishiguro', email: 'ishiguro@example.com', password: 'initialpassword', authority_id: 4)

# registers
Register.create(name: 'sweets1号店', initial_cash_amount: 0)
