class Room < ActiveRecord::Base
  #Relations
  belongs_to :user

  def complete_name
    "#{title}, #{location}"
  end

end
