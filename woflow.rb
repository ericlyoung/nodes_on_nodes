require 'httparty'

API_NODE_PATH = 'https://nodes-on-nodes-challenge.herokuapp.com/nodes/'
STARTING_NODE_ID = '089ef556-dfff-4ff2-9733-654645be56fe'

def fetch_nodes(id)
  HTTParty.get(API_NODE_PATH + id)
end

def run(acc, id = STARTING_NODE_ID)
  puts "on node id: #{id}"

  fetch_nodes(id).each do |node|
    puts node
    acc.prepend(node['id'])
    node['child_node_ids'].each { |node_id| run(acc, node_id) }
  end

  acc
end

list = []
run(list)

unique_count = list.reduce({}) { |acc, id| acc.store(id, acc.fetch(id, 0) + 1); acc }

puts '#### THE RESULTS ####'
puts 'total unique node ids'
puts unique_count.length

puts 'most common node id'
puts unique_count.sort_by{ |k,v| -v }[0]
