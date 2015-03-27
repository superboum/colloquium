require 'sinatra/activerecord'

class Review < ActiveRecord::Base
  belongs_to :lecturer, :class_name => 'User', :foreign_key => 'lecturer_id'
  belongs_to :validator, :class_name => 'User', :foreign_key => 'validator_id'
  has_many :reviewpropositions
end
