class Node
  attr_reader :tag_or_id, :data

  def initialize(tag_or_id, data)
    @tag_or_id = tag_or_id
    @data = data
  end
end

class GedcomNode < Node
  INDI = 0
  NAME = 1
  OTHER = 2

  def type
    if @data.eql?('INDI')
      INDI
    elsif tag_or_id.eql?('NAME')
      NAME
    else 
      OTHER
    end
  end

  def opening_tag
    case type
    when INDI
      "<indi id=\"#{@tag_or_id}\">"
    when NAME
      "<name value=\"#{@data}\">"
    else
      "<#{@tag_or_id.downcase}>#{@data}"
    end
  end

  def closing_tag
    case type
    when INDI
      "</#{@data.downcase}>"
    else
      "</#{@tag_or_id.downcase}>"
    end
  end
end

class Tree
  attr_accessor :root, :children

  def initialize()
    @root = nil
    @children = []
  end

  def ==(other_tree)
    @root == other_tree.root && @children == other_tree.children
  end

  def add_node(node)
    if @root == nil
      @root = node
    else
      @children.push(Tree.new().add_node(node))
    end

    self
  end

  def find_child(node)
    return self if @root == node

    @children.each { |c|
      found = c.find_child(node)
      return found if found
    }

    return nil
  end

  def to_xml(indent = 0)
    xml = ''
    has_children = ! @children.empty?

    xml << '  ' * indent << @root.opening_tag << (has_children ? "\n" : '')
    @children.each { |c|
      xml << c.to_xml(indent + 1)
    }
    xml << (has_children ? '  ' * indent : '') << @root.closing_tag << "\n"
  end
end

class Gedcom
  def initialize(gedcom_string)
    @tree = Tree.new
    previous_level = 0 
    parent_nodes = []
    gedcom_string.lines.each { |l| 
      level, tag_or_id, data = l.split(' ', 3)
      data.chomp!
      level = level.to_i
      node = GedcomNode.new(tag_or_id, data)

      if (level == 0)
        @tree.add_node(node)
        parent_nodes.push(node)
      elsif (level > previous_level)
        @tree.find_child(parent_nodes.last()).add_node(node)
        parent_nodes.push(node)
      elsif (level <= previous_level)
        parent_nodes.pop
        @tree.find_child(parent_nodes.last()).add_node(node)
      end

      previous_level = level
    }
  end

  def to_xml
    xml = ''
    xml << "<gedcom>\n"
    xml << @tree.to_xml(1)
    xml << "</gedcom>\n"
  end
end
