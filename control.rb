require_relative 'ratings.rb'
require_relative 'validator.rb'
class Control

  def run batch_num
    base_set = Ratings.new
    base_set.load_data("base", batch_num)

    test_set = Ratings.new
    test_set.load_data("test", batch_num)

    check = Validator.new
    check.validate(base_set, test_set)
    puts check.report
  end
end

c = Control.new
c.run(1)
