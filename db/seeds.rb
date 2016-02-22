require 'faker'
TYPE = ENV['SEED_TYPE']
puts "-----------------------------"

if !TYPE.nil?
	seed_file = File.dirname(__FILE__) + "/seeds/#{TYPE}_seeds"
    puts "Loading #{TYPE} seeds: \n #{seed_file}".colorize(:cyan)
elsif Rails.env.development?
    seed_file = File.dirname(__FILE__) + '/seeds/demo_seeds'
    puts "Loading demo seeds: \n #{seed_file}".colorize(:cyan)
elsif Rails.env.production? 
    seed_file = File.dirname(__FILE__) + '/seeds/install_seeds'
    puts "Loading install seeds: \n #{seed_file}".colorize(:cyan)
end

require seed_file
