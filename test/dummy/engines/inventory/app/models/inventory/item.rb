module Inventory
  class Item
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :id, :integer
    attribute :name, :string
    attribute :description, :string

    def to_param
      id&.to_s
    end

    class << self
      def search(query)
        []
      end
    end
  end
end
