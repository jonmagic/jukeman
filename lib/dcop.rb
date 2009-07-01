require 'lib/string'
class DCOPClass
  class << self
    attr_accessor :dcop

    def dcop_method(mname, args)
      mdef = {}
      puts "Doing #{args.inspect}"
      args.each do |arg|
        type, name = arg.split(/ /)
        puts "Type: #{type}, Name: #{name}"
        name = type if name.to_s == ''
        mdef[name.snake_case.gsub(/::/,'__')] = type
        puts "\tSaved #{name.snake_case.gsub(/::/,'__')} => #{type}"
      end
      arg_names = mdef.keys

      puts "
      def self.#{mname}(#{arg_names.join(', ')})
        dcop.run(\"#{mname}\", #{arg_names.empty? ? '[]' : arg_names.map {|a| ['QStringList', 'QCStringList'].include?(mdef[a]) ? "\"[ \#{[#{a}].flatten.join('\" \"')} ]\"" : a}.join(', ')})
      end"
      class_eval "
      def self.#{mname}(#{arg_names.join(', ')})
        dcop.run(\"#{mname}\", #{arg_names.empty? ? '[]' : arg_names.map {|a| ['QStringList', 'QCStringList'].include?(mdef[a]) ? "\"[ \#{[#{a}].flatten.join('\" \"')} ]\"" : a}.join(', ')})
      end"
    end
    def def_methods(method_defs)
      method_defs.each do |name, args|
        class_eval "
        def #{name}(#{args.join(', ')})
          dcop.run(\"#{name}\", #{args.empty? ? '[]' : args.map {|a| "\"\#{#{a}}\""}.join(', ')})
        end"
      end
    end
  end
end

class DCOP
  class << self
    def build!(application, options={})
      klass_name = application.camel_case
      eval("::#{klass_name} = Class.new")
      klass = ::Object.const_get(klass_name)
      dcop_base = "dcop " + (options ? options.map {|k,v| "--#{k} #{v}"}.join(' ') : '') + " #{application}"

      categories = read_list(`#{dcop_base}`)
      puts "Categories: #{categories.join(', ')}"
      categories.each {|c| c.gsub!(/ \(default\)/,'')}
      categories.select {|c| c =~ /^[A-Za-z]+$/}.each do |category|
        puts "Classifying #{category}"
        cat_name = category.camel_case
        eval("::#{klass_name}::#{cat_name} = Class.new(DCOPClass)")
        cat_klass = klass.const_get(cat_name)

        # Define dcop base
        cat_klass.dcop = DCOP.new(application, category, options)

        # Define the methods
        methods = read_list(`#{dcop_base} #{category}`)
        methods.each do |method_def|
          return_type, method_name, arguments = method_def.match(/(\w+) (\w+)\((.*)\)/)[1..3]
          puts "#{klass_name}::#{cat_name}##{method_name} (#{arguments}) -> #{return_type}"
          cat_klass.dcop_method(method_name, arguments.split(/, ?/))
        end
      end
    end

    def read_list(response)
      response.split(/\n/)
    end
  end

  def initialize(application, category, options={})
    @application = application
    @category = category
    @options = options
  end

  def run(cmd, *args)
    puts "dcop #{options_string} #{@application} #{@category} #{cmd} #{args.join(' ')}"
    `dcop #{options_string} #{@application} #{@category} #{cmd} #{args.join(' ')}`
  end

  private
    def options_string
      @options ? @options.map {|k,v| "--#{k} #{v}"}.join(' ') : ''
    end
end