require "test_helper"

class ExternalEngineTest < ActionDispatch::SystemTestCase
  driven_by :rack_test

  # Inventory::Engine mounted at /inventory inside console :admin (see dummy/config/routes.rb)
  test "external engine routes are available under console namespace" do
    visit "/admin/inventory"
    assert_text "Inventory Dashboard (external engine)"
  end

  test "added result to search index" do
    visit admin_search_index_path(format: :json)

    data = JSON.parse(page.body)
    assert_includes data, { "title" => "Inventory", "url" => "/admin/inventory/", "description" => "Manage inventory" }
    assert_includes data, { "title" => "Inventory Items", "url" => "/admin/inventory/items", "description" => "Manage inventory" }
  end

  test "adds result via search middleware" do
    item = Inventory::Item.new(id: 1, name: "Snickers", description: "Snickers bar")
    Spy.on(Inventory::Item, :search).and_return { |query| query == "Snic" ? [ item ] : [] }

    visit admin_search_path(q: "Snic")
    assert_text "Snickers bar"
  end

  test "adds link to header" do
    visit admin_root_path
    assert_selector "header .header-right a[href='/admin/inventory/items']", text: "Inventory"
  end
end
