module Catalog
  module Core

    #utility classes
    class AbstractFilterOp

      def self.get_class(class_name)
         Kernel.const_get('Catalog').const_get('Core').const_get(class_name)
      end

      def self.parse_node(node)
        class_name = node.name
        clazz = get_class(class_name)
        clazz.parse(node)
      end

      def create_literal_if_required(value)
        if value.kind_of?(AbstractFilterOp)
          value
        else
          Literal.new(value)
        end
      end
    end

    class AbstractUnaryOp < AbstractFilterOp
      attr_reader :value, :name
      
      def initialize(value)
        @name = self.class.name.split('::').last
        @value = create_literal_if_required value
      end

      def to_xml(builder)
        builder.tag!(@name) do
          @value.to_xml(builder)
        end
      end

      def self.parse(element)
        value_element = element.elements[1]
        value = parse_node(value_element)

        class_name = element.name
        clazz = get_class(class_name)
        clazz.new(value)
      end


      def ==(op)
        @value == op.value && @name == op.name 
      end
    end

    class AbstractBinaryOp < AbstractFilterOp
      attr_reader :left, :right, :name
      
      def initialize(left, right)
        @name = self.class.name.split('::').last
        @left = create_literal_if_required left
        @right = create_literal_if_required right
      end

      def to_xml(builder)
        builder.tag!(@name) do
          @left.to_xml(builder)
          @right.to_xml(builder)
        end
      end

      def self.parse(element)
        left_element = element.elements[1]
        right_element = element.elements[2]

        left = parse_node(left_element)
        right = parse_node(right_element)

        class_name = element.name
        clazz = get_class(class_name)
        clazz.new(left,right)
      end

      def ==(op)
        @left == op.left && @right == op.right && @name == op.name
      end
    end

    class AbstractPropertyOp < AbstractFilterOp
      attr_reader :name, :op_name, :value

      def initialize(name, value)
        @name = name
        @op_name = self.class.name.split('::').last
        @value = create_literal_if_required(value)
      end

      def to_xml(builder)
        builder.tag!(@op_name) do
          builder.PropertyName @name
          @value.to_xml(builder)
        end
      end

      def self.parse(element)
        name_element = element.elements['PropertyName']
        value_element = name_element.next_element
        name = name_element.text
        value = parse_node(value_element)

        class_name = element.name
        clazz = get_class(class_name)
        clazz.new(name, value)
      end

      def md_value(md)
        md.field(@name)
      end

      def required_value
         @value.value
      end

      def ==(op)
        @name == op.name && @op_name == op.op_name && @value == op.value
      end
    end


    #filter itself
    class Filter < AbstractFilterOp
      attr_reader :exp
      
      def initialize(exp)
        @exp = exp
      end

      def self.create(expression)
        Filter.new(expression)
      end

      def self.parse(xml)
        doc = REXML::Document.new(xml)
        root = doc.root
        raise CatalogException, "Filter can't be empty" unless root.has_elements?

        expression = parse_node(root.to_a[0])
        Filter.create(expression)
      end

      def self.init!
      end

      def to_xml
        b = Builder::XmlMarkup.new
        b.Filter do
          @exp.to_xml(b)
        end
      end

      def check(md)
        @exp.check(md)
      end
            
      def ==(filter)
        @exp == filter.exp
      end
    end


    #implementations of all filter operations
    class Literal < AbstractFilterOp
      def initialize(value)
        value = DateTime.parse(value) rescue value
        @value = value
      end

      def to_xml(builder)
        builder.Literal @value
      end

      def self.parse(element)
        Literal.new(element.text)
      end

      def value
        if @value == 'null' || @value == 'Null'
          nil
        else
          @value
        end
      end

      def ==(literal)
        @value == literal.value
      end
    end

    class PropertyIsEqualTo < AbstractPropertyOp
      def check(md)
        md_value(md) == required_value
      end
    end

    class PropertyIsNotEqualTo < AbstractPropertyOp
      def check(md)
        md_value(md) != required_value
      end
    end

    class PropertyIsGreaterThan < AbstractPropertyOp
      def check(md)
        md_value(md) > required_value
      end
    end

    class PropertyIsGreaterThanEqualTo < AbstractPropertyOp
      def check(md)
        md_value(md) >= required_value
      end
    end

    class PropertyIsLessThan < AbstractPropertyOp
      def check(md)
        md_value(md) < required_value
      end
    end

    class PropertyIsLessThanEqualTo < AbstractPropertyOp
      def check(md)
        md_value(md) <= required_value
      end
    end

    class PropertyIsLike < AbstractPropertyOp
      def check(md)
        ! md_value(md).match(required_value).nil?
      end
    end

    class BBOX < AbstractPropertyOp
      def check(md)
#        required_value.bbox(md_value(md))
        true
      end
    end

    class And < AbstractBinaryOp
      def check(md)
        left.check(md) && right.check(md)
      end
    end

    class Or < AbstractBinaryOp
      def check(md)
        left.check(md) || right.check(md)
      end
    end

    class Not < AbstractUnaryOp
      def check(md)
        !value.check(md)  
      end
    end
  end
end
