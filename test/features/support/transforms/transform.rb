ISBN = Transform /^\d+{10}$/ do |number|
	number.to_i
end

PRICE = Transform /^(\d+.\d+)$/ do |number|
	number #.to_i
end
