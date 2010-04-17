class Formatter

  class << self 
    attr_accessor :formatters #:nodoc:
  end

  self.formatters = {}

  def self.define(name,options={},&block)
    instance = Formatter.new name,options,&block
    self.formatters[name.to_sym] = instance

    formatter_name = name.to_s
    ActiveRecord::Base.class.class_eval do 
      define_method "#{formatter_name}_format" do |*attrs|
        options = attrs.pop if attrs.last.kind_of? Hash
        options ||= {}
        attrs.each do |attr_name|
          define_method "#{formatter_name}_formatted_#{attr_name}" do 
            Formatter.formatters[formatter_name.to_sym].impl.call(self.send(attr_name),options)
          end 
        end
      end
    end 
  end

  attr_accessor :name, :options,:impl

  def initialize(name,options,&block)
    @name = name
    @options = options
    @impl = block
  end

end

