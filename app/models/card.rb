class Card
    include ActiveModel::Model
    attr_accessor :name, :number, :expiration_month, :expiration_year, :security_code

    validates :name, :number, :expiration_month, :expiration_year, :security_code, presence: true
    validates :number, :expiration_month, :expiration_year, :security_code, :numericality => { only_integer: true }

    def self.attributes
        @attributes
    end

    def initialize attributes={}
        attributes && attributes.each do |name, value|
            send("#{name}=", value) if respond_to? name.to_sym 
        end
    end
end 
