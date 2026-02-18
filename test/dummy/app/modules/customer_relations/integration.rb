module CustomerRelations
  class Integration < RapidlyBuilt::Integration::Base
    def call
      search.index.add_result(
        title: "Contacts",
        url: helpers.admin_contacts_path,
        description: "Manage current and potential customers"
      )

      search.middleware.use ContactsSearch

      request.middleware.use RequestMiddleware
    end
  end
end
