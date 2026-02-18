require "test_helper"

class InternalModuleTest < ActionDispatch::SystemTestCase
  driven_by :rack_test

  # defined in dummy/config/routes.rb
  test "internal routes are available" do
    visit admin_root_path
    assert_text "Dashboard Show"

    visit admin_contacts_path
    assert_text "Contacts Index"
  end

  # integrated via dummy/app/modules/customer_relations/integration.rb
  test "added result to search index" do
    visit admin_search_index_path(format: :json)
    assert_text({ title: "Contacts", url: "/admin/contacts", description: "Manage current and potential customers" }.to_json)
  end

  # integrated via dummy/app/modules/customer_relations/integration.rb
  # defined in dummy/app/modules/customer_relations/contacts_search.rb
  test "adds result via search middleware" do
    contact = Contact.new(id: 1, first_name: "John", last_name: "Doe", company_name: "Acme Inc", email: "john@example.com")

    # Stub the Contact.search class method
    Spy.on(Contact, :search).and_return { |query| query == "John" ? [contact] : [] }

    visit admin_search_path(q: "John")
    assert_text "Results for \"John\""
    assert_text "John Doe"

    visit admin_search_path(q: "Jane")
    assert_text "Results for \"Jane\""
    assert_text "No results found"
    refute_text "John Doe"
  end

  # integrated via dummy/app/modules/customer_relations/integration.rb
  # defined in dummy/app/modules/customer_relations/request_middleware.rb
  test "adds link to header" do
    visit admin_root_path
    assert_selector "header .header-right a[href='/admin/contacts']", text: "Contacts"
  end
end
