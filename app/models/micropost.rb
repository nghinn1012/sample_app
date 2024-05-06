class Micropost < ApplicationRecord
  belongs_to :user
  scope :newest, ->{order(created_at: :desc)}
  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: Settings.img.size_250_250
  end
  validates :content, presence: true,
  length: {maximum: Settings.digit_140}
  validates :image,
            content_type: {in: Settings.img.content_type,
                           message: I18n.t("micropost.errors.content_type")},
            size: {less_than: Settings.img.max_size.megabytes,
                   message: I18n.t("micropost.errors.alert_max_size")}
end
