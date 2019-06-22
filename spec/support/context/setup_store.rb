RSpec.shared_context "setup store" do
  CONFIG[:stores].each { |n| Store.create!({ name: n }) }
end
