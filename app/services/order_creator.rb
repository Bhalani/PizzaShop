class InsufficientInventoryError < StandardError; end

class OrderCreator
  CRUST_QUANTITY_PER_PIZZA = 1

  def initialize(order_params)
    @order_params = order_params
    @order = Order.new
  end

  def call
    ActiveRecord::Base.transaction do
      validate_and_reserve_inventory
      calculate_total_price
      assign_order_attributes
      @order.save!
    end
    @order
  rescue ActiveRecord::RecordNotFound, InsufficientInventoryError, ActiveRecord::RecordInvalid => e
    @order.errors.add(:base, e.message)
    @order
  rescue => e
    @order.errors.add(:base, "An unexpected error occurred: #{e.message}")
    @order
  ensure
    ActiveRecord::Base.connection_pool.release_connection
  end

  private

  def assign_order_attributes
    @order.assign_attributes(@order_params)
  end

  def validate_and_reserve_inventory
    reserve_pizza_inventory if @order_params[:order_pizzas_attributes]
    reserve_side_inventory if @order_params[:order_sides_attributes]
  end

  def reserve_pizza_inventory
    @order_params[:order_pizzas_attributes].values.each do |pizza_params|
      validate_pizza_params(pizza_params)
      reserve_inventory_by_name(pizza_params[:crust], CRUST_QUANTITY_PER_PIZZA)
      reserve_topping_inventory(pizza_params[:order_pizza_toppings_attributes])
    end
  end

  def reserve_side_inventory
    @order_params[:order_sides_attributes].values.each do |side_params|
      reserve_inventory_for(side_params[:inventory_id], side_params[:quantity])
    end
  end

  def reserve_topping_inventory(toppings_attributes)
    return unless toppings_attributes

    toppings_attributes.values.each do |topping_params|
      reserve_inventory_for(topping_params[:inventory_id], topping_params[:quantity])
    end
  end

  def reserve_inventory_for(inventory_id, quantity)
    Inventory.transaction do
      inventory = find_inventory(inventory_id)
      inventory.with_lock { reserve_inventory_if_available(inventory, quantity) }
    end
  end

  def reserve_inventory_by_name(name, quantity)
    Inventory.transaction do
      inventory = find_inventory_by_name(name)
      inventory.with_lock { reserve_inventory_if_available(inventory, quantity) }
    end
  end

  def reserve_inventory_if_available(inventory, quantity)
    raise InsufficientInventoryError, "Insufficient quantity for #{inventory.name}" if quantity.to_i > inventory.quantity

    inventory.update!(quantity: inventory.quantity - quantity.to_i)
  end

  def calculate_total_price
    @order_params[:total_price] = pizza_total + side_total
  end

  def pizza_total
    return 0 unless @order_params[:order_pizzas_attributes]

    @order_params[:order_pizzas_attributes].values.sum do |pizza_params|
      pizza_params[:price] = calculate_base_pizza_price(pizza_params)
      assign_topping_prices(pizza_params)
      pizza_params[:price] + topping_total_price(pizza_params)
    end
  end

  def calculate_base_pizza_price(pizza_params)
    pizza = find_pizza(pizza_params[:pizza_id])
    pizza_size = find_pizza_size(pizza, pizza_params[:size])
    pizza_size.price * pizza_params[:quantity].to_i
  end

  def assign_topping_prices(pizza_params)
    return unless pizza_params[:order_pizza_toppings_attributes]

    free_toppings = (pizza_params[:size] == "large" ? 2 : 0) * pizza_params[:quantity].to_i

    pizza_params[:order_pizza_toppings_attributes].values.each do |topping_params|
      topping_params[:price] = calculate_topping_price(topping_params, free_toppings)
      free_toppings = [ free_toppings - topping_params[:quantity].to_i, 0 ].max
    end
  end

  def topping_total_price(pizza_params)
    return 0 unless pizza_params[:order_pizza_toppings_attributes]

    pizza_params[:order_pizza_toppings_attributes].values.sum { |topping_params| topping_params[:price] }
  end

  def calculate_topping_price(topping_params, free_toppings)
    inventory = find_inventory(topping_params[:inventory_id])
    chargeable_quantity = [ topping_params[:quantity].to_i - free_toppings, 0 ].max
    chargeable_quantity * inventory.price_per_piece
  end

  def side_total
    return 0 unless @order_params[:order_sides_attributes]

    @order_params[:order_sides_attributes].values.sum do |side_params|
      inventory = find_inventory(side_params[:inventory_id])
      inventory.price_per_piece * side_params[:quantity].to_i
    end
  end

  def validate_pizza_params(pizza_params)
    required_keys = %w[crust size quantity]
    missing_keys = required_keys - pizza_params.keys
    raise ArgumentError, "Missing pizza parameters: #{missing_keys.join(', ')}" if missing_keys.any?
  end

  def find_inventory_by_name(name)
    Inventory.lock.find_by(name: name) || raise(ActiveRecord::RecordNotFound, "Inventory out of menu: #{name}")
  end

  def find_inventory(id)
    Inventory.lock.find(id)
  end

  def find_pizza(id)
    Pizza.lock.find_by(id: id) || raise(ActiveRecord::RecordNotFound, "Pizza out of menu")
  end

  def find_pizza_size(pizza, size)
    pizza.pizza_sizes.lock.find_by(size: size) || raise(ActiveRecord::RecordNotFound, "Pizza size out of menu: #{size}")
  end
end
