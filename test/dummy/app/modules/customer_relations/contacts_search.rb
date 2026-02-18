module CustomerRelations
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
end
