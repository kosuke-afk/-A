class User < ApplicationRecord
  has_many :attendances, dependent: :destroy
  has_many :months, dependent: :destroy
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  validates :affiliation, length: { in: 2..30 }, allow_blank: true
  validates :designated_work_start_time, presence: true
  validates :designated_work_end_time, presence: true
  validates :basic_work_time, presence: true
  validates :uid, presence: true, uniqueness: true
  validates :employee_number, presence: true, uniqueness: true
  
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  
  # 渡された文字列のハッシュ化
  def User.digest(string)
    cost = 
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end
  
  # ランダムな文字列を返す。
  def User.new_token
    SecureRandom.urlsafe_base64
  end
  
  # 永続化セッションのためにremember_digestを保存する。
  def remember
    self.remember_token = User.new_token # 認証に必要な仮属性のremember_tokenにハッシュ化する前の値を入れている。
    update_attribute(:remember_digest, User.digest(remember_token))  # remember_digestにremember_tokenをハッシュ化したものを入れて更新
  end
  
  
  def forget
    update_attribute(:remember_digest, nil)
  end
  
  # remember_tokenとremember_digestの認証に使う。 トークンとダイジェストが一致すれば、true
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  def self.search(search)
    if search
      User.where(['name LIKE ?', "%#{search}%"])
    else
      User.all
    end
  end
  
  # def self.import(file)
  #   ActiveRecord::Base.transaction do
  #     CSV.foreach(file.path, headers: true) do |row|
  #       user = new
  #       user.attributes = row.to_hash.slice(*updatable_attributes)
  #       user.save!
  #     end
  #   rescue ActiveRecord::RecordInvalid
  #     yield
  #   end
  # end
  
  # def self.updatable_attributes
  #   ['name','email','password','password_confirmation','affiliation','designated_work_start_time', 'designated_work_end_time']
  # end
  
end
