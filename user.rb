class User

  attr_accessor :rated_movies
  attr_accessor :similar_users
  def initialize
    @rated_movies = Hash.new
    @similar_users = Hash.new
  end

  def rated movie_id
    if !@rated_movies[movie_id]
      -1
    else
      @rated_movies[movie_id][0]
    end
  end

  def rate movie_id, rating, timestamp
    @rated_movies[movie_id] = [rating,timestamp]
  end

  def rated_movies
    @rated_movies.keys
  end

  #The same similarity algorithm as the previous assignment
  def similarity other_user
    their_movies = other_user.rated_movies
    similarity_factor = 0
    if their_movies.length < @rated_movies.length
      similarity_factor = compare_lists(their_movies, @rated_movies)
    else
      similarity_factor = compare_lists(@rated_movies,their_movies)
    end
    @similar_users[other_user] = similarity_factor
    other_user.similar_users[self] = similarity_factor
    similarity_factor
  end

  def compare_lists(a, b)
    shared = 0
    a.each do |m|
      if b.include?(m)
        shared += 1
      end
    end
    return shared.to_f/a.length
  end




end
