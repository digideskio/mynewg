require 'csv'
class User < ActiveRecord::Base
    include HasRoles
    include HasSalesCode
    include HasUsername
    include HasPhotos
    include HasEvents
    include HasCommissions
    include HasManagements
    include HasTransactions
    include HasOmiseCustomers
    include HasChats
    include HasDateOfBirth
    include HasFavourites
    include HasNotifications
    include HasBlocks
    include HasDiscountCodes
    include HasFlags
    include HasPackagePricePurchaseValidation
    include HasRepresentatives
    include HasPassword
    include HasTokenAuth

    attr_accessor :login

    devise :database_authenticatable, :rememberable, :trackable, :validatable, :omniauthable, :registerable, omniauth_providers: [:facebook]
    include DeviseTokenAuth::Concerns::User

    belongs_to :package

    has_many :searches

    validates :name, :gender,                               presence: true
    validates :phone,                                       presence: true
    validates :phone,                                       uniqueness: true, :if => :number_not_zero?
    validates :package_id,                                  presence: true, :if => :member?
    validates :email,                                       presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
    validates :biography,                                   length: { maximum: 140 }

    before_validation :prune_phone
    before_validation :assign_package
    before_validation :assign_email

    before_destroy :stop_rep_admin_delete


    enum drink:             %i(drink_never drink_socially drink_yes)
    enum english:           %i(en_none en_little_bit en_good en_fluent)
    enum gender:            %i(female male)
    enum smoke:             %i(smoke_never smoke_socially smoke_yes)
    enum status:            %i(active freeze suspended)
    enum thai:              %i(th_none th_little_bit th_good th_fluent)

    def self.to_csv
        attributes = User.new.attributes.keys

        CSV.generate(headers: true) do |csv|
            csv << attributes
            all.each do |user|
                csv << attributes.map{ |attr| user.send(attr) }
            end
        end
    end

    def self.find_first_by_auth_conditions warden_conditions
        conditions = warden_conditions.dup

        if login = conditions.delete(:login)
            where(conditions).where(['lower(phone) = :value OR lower(email) = :value', { :value => login.downcase }]).first
        else
            where(conditions).first
        end
    end

    def full_display_name
        display_name.blank? || display_name.nil? ? name : display_name
    end

    def active_for_authentication?
        super && !suspended?
    end

    def inactive_message
        if suspended?
            :suspended
        else
            super
        end
    end

    def stop_rep_admin_delete
        return false unless self.member? || self.lead? || self.limited?
    end

    def number_not_zero?
        return phone == "0" ? false : true
    end

    private

    def assign_email
        self.email = email.present? ? email.downcase : "member#{User.last.id + 1}@mynewg.com"
    end

    def assign_package
        self.package_id = Package.find_by_tier(0).id if self.new_record?
    end

    def prune_phone
        self.phone.gsub!(/[^\d\+]/, '') if phone.present?
    end
end
