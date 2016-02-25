class User
  include Mongoid::Document
  include Mongoid::Timestamps

  before_validation :generate_password

  # default
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :trackable, :validatable
  # other :confirmable, :lockable, :timeoutable, :omniauthable

  devise :omniauthable, :omniauth_providers => [:google_oauth2]
  devise :database_authenticatable, :rememberable, :trackable, :validatable

  validates_uniqueness_of :email, :allow_blank => :true

  field :name, :type => String
  field :email, :type => String
  field :encrypted_password, :type => String

  field :remember_created_at, :type => Time
  field :sign_in_count, :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at, :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip, :type => String

  field :roles, :type => Array, :default => []

  ROLES = ['admin', 'member']

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(:email => data['email']).first

    unless user
      user = User.create(:name => data['name'], :email => data['email'])
    end

    return user
  end

  def self.get_user_names
    user_collection = User.collection.aggregate([
      {
        :$project => {
          :_id => '$_id',
          :name => '$name'
        }
      }
    ])

    user_names = {}

    user_collection.each do |user|
      id = user['_id'].to_s
      name = user['name']
      user_names[id] = name
    end

    return user_names
  end

  def generate_password
    self.password = Devise.friendly_token[0, 20] if self.encrypted_password.nil?
  end

  def email_required?
    false
  end

end
