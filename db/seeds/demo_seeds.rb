puts "-----------------------------"
puts "Starting demo seeds:".colorize(:cyan)

require File.dirname(__FILE__) +  '/demo/package_seeds'
require File.dirname(__FILE__) +  '/demo/admin_seeds'
require File.dirname(__FILE__) +  '/demo/user_seeds'
require File.dirname(__FILE__) +  '/demo/event_seeds'
require File.dirname(__FILE__) +  '/demo/sale_transaction_seeds'
require File.dirname(__FILE__) +  '/demo/message_seeds'

puts "-----------------------------"
puts "Finished demo seeds".colorize(:cyan)
