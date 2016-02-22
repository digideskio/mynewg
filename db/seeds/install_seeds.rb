puts "-----------------------------"
puts "Starting install seeds:".colorize(:cyan)

require File.dirname(__FILE__) +  '/install/package_seeds'
require File.dirname(__FILE__) +  '/install/admin_seeds'
require File.dirname(__FILE__) +  '/install/event_seeds'

puts "-----------------------------"
puts "Finished install seeds".colorize(:cyan)
