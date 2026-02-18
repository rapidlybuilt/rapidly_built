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

  class ContactsSearch < RapidlyBuilt::Search::Middleware::Entry
    def call
      Contact.search(query_string).each do |contact|
        add_result(
          title: contact.full_name,
          url: helpers.admin_contact_path(contact),
          description: "#{contact.company_name} - #{contact.email}"
        )
      end
    end
  end

  class RequestMiddleware < RapidlyBuilt::Request::Middleware::Entry
    def call
      layout.header.right.build_text_link("Contacts", helpers.admin_contacts_path)
    end
  end
end
