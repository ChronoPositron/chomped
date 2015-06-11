require 'url_hash/transform'

class Url < ActiveRecord::Base
  before_destroy :destroy_is_confirmed?

  has_secure_token :delete_token
  validates :original, presence: true, uri: true

  attr_accessor :delete_token_confirmation

  def to_param
    Url.encode(id)
  end

  def self.encode(num)
    UrlHash::Transform.new(Rails.application.secrets.hashids_salt).encode(num)
  end

  def self.decode(str)
    UrlHash::Transform.new(Rails.application.secrets.hashids_salt).decode(str)
  end

  private

  def destroy_is_confirmed?
    unless delete_token == delete_token_confirmation
      errors.add(:delete_token_confirmation, :bad_delete_token)
    end

    errors.blank? # If there are no errors, delete the record, otherwise, bail.
  end
end
