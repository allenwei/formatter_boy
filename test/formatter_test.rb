require 'test_helper'

class FormatterTest < Test::Unit::TestCase

  context "" do 
    should "default value of formatter" do 
      assert Formatter.formatters.empty? 
    end

    should "have one formatter if I defined one" do
      Formatter.define :money do |input,options|
        ""
      end
      assert_equal 1, Formatter.formatters.size
      Formatter.define :money do 
        ""
      end
      assert_equal 1, Formatter.formatters.size
    end
  end

  context "a class Book and two formatter" do 
    setup do 
      Formatter.define :round do |input,options|
        input.round
      end
      Formatter.define :wrapper do |input,options|
        "#{options[:prefix]} #{input}#{options[:suffix]}"
      end
    end

    should "added to active record class" do 
      class Book < ActiveRecord::Base
        attr_accessor :name, :price
        round_format :price
        wrapper_format :name, :prefix => "I'm", :suffix => "."
      end
      book = Book.new :name => "Allen", :price => 3.1415926
      assert_equal 3,book.round_formatted_price
      assert_equal "I'm Allen.",book.wrapper_formatted_name
    end

    context "extend" do 
      should "be supported" do 
        Formatter.define :prefix,:parent => :wrapper,:options => {:suffix => "."}             
        class Book < ActiveRecord::Base
          attr_accessor :name, :price
          prefix_format :name, :prefix => "I'm"
        end
        book = Book.new :name => "Allen", :price => 3.1415926
        assert_equal "I'm Allen.",book.prefix_formatted_name
      end
    end

    should "raise exception if no parent and block passed" do 
      assert_raise RuntimeError do 
        Formatter.define :prefix             
      end
    end


  end
end
