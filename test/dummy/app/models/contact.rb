class Contact
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :id, :integer
  attribute :first_name, :string
  attribute :last_name, :string
  attribute :email, :string
  attribute :company_name, :string

  def full_name
    "#{first_name} #{last_name}"
  end

  def to_param
    id&.to_s
  end

  class << self
    def search(query)
      raise NotImplementedError, "Not implemented"
    end
  end
end
