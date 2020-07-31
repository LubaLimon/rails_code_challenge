module OrdersHelper
  def query_field_params(query_field)
    options_for_select([
      ['Order number', 'orders.number'],
      ['Order state', 'orders.state'],
      ['Email', 'users.email'],
      ['Username', 'users.name'],
      ['State', 'addresses.state'],
      ['Ciry', 'addresses.city']
    ],
    query_field)
  end
end
