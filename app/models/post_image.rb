class PostImage < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  with_options presence: true, on: :publicize do
    validates :shop_name
    validates :image
    validates :address
  end

  validates :shop_name, length: { maximum: 20 }, on: :publicize

  geocoded_by :address
  after_validation :geocode
  
  def get_image
    unless image.attached?
      file_path = Rails.root.join("app/assets/images/no_image.jpg")
      image.attach(io: File.open(file_path), filename: "defalt-image.jpg", content_type: "image/jpeg")
    end
    image
  end

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
end
