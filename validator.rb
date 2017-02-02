require 'descriptive-statistics'
class Validator




  def initialize
    @results = Array.new
  end

  #takes two Ratings Objects.
  def validate base_set, test_set
    test_users = test_set.users
    test_users.each do |k, u|
      u.rated_movies.each do |m|
        guess = base_set.predict(k, m)
        actual = u.rated(m)
        if guess >= 0
          @results.push (actual - guess).abs
        end
      end


    end
  end

  def report
    stats = DescriptiveStatistics::Stats.new(@results)
    stats_report = <<-report
    Number of perfect guesses: #{@results.count(0)}
    Number of guesses only 1 off #{@results.count(1)}
    Mean of the errors: #{stats.mean}
    Mode of errors: #{stats.mode}
    Standard Deviation of error: #{stats.standard_deviation}
    report
    return stats_report

  end



end
