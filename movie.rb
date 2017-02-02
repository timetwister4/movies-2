class Movie

  attr_accessor :rating_users

  def initialize
    @rating_users = Array.new
  end

  def rated user_id
    rating_users.push user_id
  end

end
