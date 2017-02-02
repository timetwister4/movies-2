require_relative 'user.rb'
require_relative 'movie.rb'
require 'byebug'

class Ratings

  attr_accessor :users
  attr_accessor :movies

  def initialize
    @users = Hash.new
    @movies = Hash.new
  end

  def load_data batch_type, batch_num=nil
    file_path = "ml-100k/u" + (batch_num.to_s ||="") + ".#{batch_type}"
    data = open(file_path)

    entries = data.read.split("\n")

    entries.each do |e|
      items = e.split("\t").map!{|i| i.to_i}
      add_rating(items[0], items[1], items[2], items[3])
    end

  end

  def add_rating user_id, movie_id, rating, timestamp
    #initialize a user when seen for the first time.
    if !@users[user_id]
      @users[user_id] = User.new
    end

    #initialize a movie when seen for the first time.
    if !@movies[movie_id]
      @movies[movie_id] = Movie.new
    end
    @users[user_id].rate(movie_id, rating, timestamp)
    @movies[movie_id].rated(@users[user_id])

  end


  def predict user_id, movie_id
    #get the user we are predicting for
    user = @users[user_id]
    #get the users we are using for comparison
    movie =  @movies[movie_id]

    if user && movie
      # holder for sum of weighted ratings
      sum = 0
      #number of users whose ratings are averaged
      similar_users = 0
      #collect user pool
      other_users = movie.rating_users
      #iterate through list of other users

      other_users.each do |u|
        #get the user's score of the movie
        their_score = u.rated(movie_id)
        unless their_score == -1
          similarity_factor = (user.similar_users[u] ||=u.similarity(u))#compare similarity of users
          if similarity_factor >= 50
            similar_users += 1
            sum += their_score * similarity_factor/100.0
          end
        end
      end
      if sum > 0
        return sum / similar_users
      else
        return -1 #insufficient data
      end
    else
      return -1 # error, user or movie does not exist
    end

  end

end
