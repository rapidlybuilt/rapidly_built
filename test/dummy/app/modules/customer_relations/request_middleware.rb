module CustomerRelations
  class RequestMiddleware < RapidlyBuilt::Request::Middleware::Entry
    def call
      layout.header.right.build_text_link("Contacts", helpers.admin_contacts_path)
    end
  end
end
