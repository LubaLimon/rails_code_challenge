# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

USER_COUNT = 20
ADDRESS_COUNT = USER_COUNT - 5
PRODUCT_COUNT = 100
COUPON_COUNT = 2
TAX_COUNT = 1

def create_order(user:, address:, order_state:, building_at:, product_count:, has_coupon:, has_tax:)
  number = "M" + Array.new(5){rand(9)}.join

  order_attributes = {
    number: number,
    user: user,
    address: address,
    state: order_state,
    building_at: building_at,
    total: 0
  }

  if order_state == Order::ARRIVED
    order_attributes[:arrived_at] = building_at + 5.days
  elsif order_state == Order::CANCELED
    order_attributes[:canceled_at] = building_at + 5.days
  end

  order = Order.create!(order_attributes)

  order_items = @products.sample(product_count).map do |product|
    quantity = (1..3).to_a.sample
    state = order.state == Order::CANCELED ? OrderItem::RETURNED : OrderItem::SOLD

    OrderItem.new(
      order: order,
      source: product,
      quantity: quantity,
      price: (quantity * product.msrp).round(2),
      state: state
    )
  end

  if has_coupon
    coupon = @coupons.sample
    order_items.push(OrderItem.new(
      order: order,
      source: coupon,
      quantity: 1,
      price: -coupon.amount
    ))
  end

  if has_tax
    tax = @taxes.sample
    price = (order_items.sum(&:price) * tax.rate).round(2)
    order_items.push(OrderItem.new(
      order: order,
      source: tax,
      quantity: 1,
      price: price
    ))
  end

  order_items.each(&:save!)

  payment_attributes = {
    order: order,
    amount: order_items.sum(&:price),
    completed_at: order.building_at,
    payment_type: Payment::PAYMENT_TYPES.sample
  }

  if order.state == Order::CANCELED
    payment_attributes[:refunded_at] = order.canceled_at
    payment_attributes[:state] = Payment::REFUNDED
  else
    payment_attributes[:state] = Payment::COMPLETED
    order.update_columns(total: order_items.sum(&:price))
  end

  Payment.create!(payment_attributes)

  order
end

puts "Creating #{USER_COUNT} users"
users = USER_COUNT.times.map do
  name = Faker::Name.unique.name
  User.create!(
    name: name,
    email: Faker::Internet.safe_email(name: name)
  )
end

puts "Creating #{ADDRESS_COUNT} addresses"
addresses = users.sample(ADDRESS_COUNT).map do |user|
  Address.create!(
    user: user,
    address1: Faker::Address.street_address,
    address2: ([true, false].sample ? Faker::Address.secondary_address : nil),
    city: Faker::Address.city,
    state:  Faker::Address.state_abbr,
    zipcode: Faker::Address.zip_code.first(5)
  )
end

puts "Creating #{PRODUCT_COUNT} products"
@products = PRODUCT_COUNT.times.map do |i|
  msrp = (20..60).to_a.sample
  Product.create!(
    msrp: msrp,
    cost: (msrp / 3),
    name: Faker::Commerce.product_name,
    sku: "#{"%03d" % i}-#{("A"..."Z").to_a.sample}"
  )
end

puts "Creating #{COUPON_COUNT} coupons"
@coupons = COUPON_COUNT.times.map do
  Coupon.create!(
    name: Faker::Commerce.promotion_code(digits: 2),
    amount: Faker::Commerce.price
  )
end

puts "Creating #{TAX_COUNT} taxes"
@taxes = TAX_COUNT.times.map do
  Tax.create!(
    name: "Sales Tax",
    rate: 0.056
  )
end

puts "Creating at least #{addresses.count} orders"
addresses.each do |address|
  product_count = (3..10).to_a.sample
  has_coupon = [true, false, false].sample
  has_tax = [true, false].sample
  user = address.user
  building_at = Faker::Date.between(from: 30.days.ago, to: 15.days.ago)

  create_order(
    user: user,
    order_state: Order::STATES.sample,
    address: address,
    building_at: building_at,
    product_count: product_count,
    has_coupon: has_coupon,
    has_tax: has_tax
  )

  if has_coupon
    2.times do
      building_at = Faker::Date.between(from: building_at, to: 5.days.ago)
      create_order(
        user: user,
        order_state: Order::STATES.sample,
        address: address,
        building_at: building_at,
        product_count: product_count,
        has_coupon: false,
        has_tax: has_tax
      )
    end
  end

end