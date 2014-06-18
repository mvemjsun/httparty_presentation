module Helper
  def self.randomize_data(value)
    case value

    when Array then value[rand(value.size)]

    when Range then rand((value.last+1) - value.first) + value.first

    else value
      
    end
  end   
end