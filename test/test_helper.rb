require 'rubygems'
require 'active_support'
require 'shoulda'
require 'active_record'
require "ruby-debug"

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'acts_as_formatter'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3",:database => ":memory:")
ActiveRecord::Schema.verbose = false
ActiveRecord::Schema.define(:version => 1) do 
  create_table :books do |t|
    t.string :name
    t.decimal :price, :precision => 3,:scale => 2, :default => 0
  end
end

class Book < ActiveRecord::Base
  attr_accessor :name, :price
end
