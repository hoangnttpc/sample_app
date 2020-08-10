class Micropost < ApplicationRecord
  MICROPOST_PARAMS = %i(content image).freeze

  belongs_to :user
  has_one_attached :image

  delegate :name, to: :user, prefix: true

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.micropost.content.length_max}
  validates :image, content_type: {in: Settings.micropost.image.content_type,
                                   message: I18n.t("microposts.image.valid_image_format")},
    size: {less_than: Settings.files.pic_size.megabytes,
           message: I18n.t("microposts.image.valid_image_size", count: Settings.files.pic_size)}

  scope :by_created_at, ->{order created_at: :desc}
  scope :feed_by_user, ->(user_ids){where user_id: user_ids}

  def display_image
    image.variant(resize_to_limit: [Settings.files.pic_resize, Settings.files.pic_resize])
  end
end
