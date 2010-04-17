require 'test_helper'


class ActsAsFormatterTest < Test::Unit::TestCase
  context "Book class" do 

    should "create database and ActiveRecord model successfully" do 
      assert book = Book.create(:name => "Allen",:price => 10)
      assert_equal "Allen", book.name
      assert_equal 10, book.price
    end
  end
end
