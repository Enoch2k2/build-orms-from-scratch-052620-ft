class Pet < ActiveRecord::Base
  belongs_to :owner

  validates :name, presence: true
  validates_presence_of :species

end