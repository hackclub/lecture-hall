class Project < ApplicationRecord
  belongs_to :user

  validates_presence_of :name
  validates :live_url, format: { with: URI.regexp }, if: "live_url.present?"
end
