# RapidlyBuilt

RapidlyBuilt is an open foundation for building consoles to operate, observe, and manage your application.

It provides a unified, extensible Console that brings together modules into a single, coherent interface.

## The Model

RapidlyBuilt is structured around three core concepts:

### Console

The Console is a structured container that:

* Provides a shared layout
* Integrates modules

### Module

A self-contained feature component.

Modules may be:

* Native Rails namespaces within your app
* Rails engines
* Open source gems
* Commercially licensed add-ons

### Integration

The mechanism that connects the module to the console by exposing:

* Search terms
* Console layout customizations

The Console doesn’t "know” about implementation details — it simply integrates modules
that conform to the integration contract.


## Why RapidlyBuilt?

Modern web apps accumulate operational needs:

* Error monitoring
* Analytics
* Background job inspection
* Data exploration
* CRM tooling
* Marketing systems
* Internal dashboards

Most teams rent these as disconnected SaaS tools.

RapidlyBuilt gives you a different path:

* Centralized operational interface
* Open source core
* Optional licensed extensions
* Self-hosted by default
* Fully extensible

You control the stack. You control the data. You control the surface area.


## Installation

Add this line to your application's Gemfile:

```ruby
gem "rapidly_built"
```

Then mount your console:

```ruby
# config/routes.rb
console :admin do
  # internal routes defined by your application
  # under the "Admin" namespace
  root to: "dashboard#show"

  # admin contact management
  resources :contacts
end
```

Define your console:

```ruby
# app/view_components/admin_console.rb
class AdminConsole < RapidlyBuilt::Console::Base
  def build
    integrate CustomerRelations
    integrate RapidlyBuilt::ErrorTracking
  end
end
```

Define your integration:

```ruby
module CustomerRelations
  class CustomerRelations::Integration < RapidlyBuilt::Integration::Base
    def call
      # static search results never are always available,
      # allowing almost immediate type-ahead results.
      search.index.add_result(
        title: "Contacts",
        url: helpers.contacts_path,
        description: "Manage current and potential customers"
      )

      # dynamically searches the database for contacts
      search.middleware.use ContactsSearch

      # ran before every request to this console
      request.middleware.use RequestMiddleware
    end
  end
end
```

Define what you just integrated:

```ruby
module CustomerRelations
  class CustomerRelations::ContactsSearch < RapidlyBuilt::Search::Middleware::Entry
    def call
      # search the database and add any contact matches
      Contact.search(query_string).find_each do |contact|
        add_result(
          title: contact.full_name,
          url: helpers.admin_contact_path(contact),
          description: "#{contact.company_name} - #{contact.email}"
        )
      end
    end
  end
end
```

```ruby
module CustomerRelations
  class RequestMiddleware < RapidlyBuilt::Request::Middleware::Base
    def call
      # add a "Customers" link to the header
      layout.header.right.text_link("Customers", helpers.admin_contacts_path)
    end
  end
end
```


## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
