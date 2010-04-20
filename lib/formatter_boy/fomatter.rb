class Formatter

  class << self 
    attr_accessor :formatters #:nodoc:
  end

  self.formatters = {}
  self.definition_file_paths = %w(lib/formatters)


  def self.find_definitions #:nodoc:
    definition_file_paths.each do |path|
      require("#{path}.rb") if File.exists?("#{path}.rb")

      if File.directory? path
        Dir[File.join(path, '*.rb')].each do |file|
          require file
        end
      end
    end
  end
  

  def self.define(name,options={},&block)
    instance = Formatter.new name,options,&block
    self.formatters[name.to_sym] = instance
    parent = options[:parent]
    extend_options = options[:options] 
    extend_options ||= {}
    raise "You must supply a parent if you don't using block in formatter #{name}" if parent.nil? && block.nil?
    formatter_name = name.to_s
    ActiveRecord::Base.class.class_eval do 
      define_method "#{formatter_name}_format" do |*attrs|
        options = attrs.pop if attrs.last.kind_of? Hash
        options ||= {}
        options.merge! extend_options
        attrs.each do |attr_name|
          define_method "#{formatter_name}_formatted_#{attr_name}" do 
            if parent
              Formatter.formatter_by_name(parent).impl.call(self.send(attr_name),options)
            else
              Formatter.formatters[formatter_name.to_sym].impl.call(self.send(attr_name),options)
            end
          end 
        end
      end
    end 
  end

  def self.formatter_by_name(name)
    formatters[name.to_sym] or raise ArgumentError.new("No such formatter: #{name.to_s}")
  end
  

  attr_accessor :name, :options,:impl

  def initialize(name,options,&block)
    @name = name
    @options = options
    @impl = block
  end

end

