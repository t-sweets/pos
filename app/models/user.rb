# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable
  include DeviseTokenAuth::Concerns::User

  enum authority: {
    admin: 0,
    arriver: 1
  }
end
