require 'spec_helper'

describe GedcomNode do
  describe '#opening_tag' do
    it 'should emit the appropriate element for an INDI node' do
      GedcomNode.new('@I1@', 'INDI').opening_tag.should == '<indi id="@I1@">'
    end

    it 'should emit the appropriate element for a NAME node' do
      GedcomNode.new('NAME', 'Jamis Gordon /Buck/').opening_tag.should == '<name value="Jamis Gordon /Buck/">'
    end

    it 'should emit the appropriate element for any other node' do
      GedcomNode.new('GIVN', 'Jamis Gordon').opening_tag.should == '<givn>Jamis Gordon'
    end
  end

  describe '#closing_tag' do
    it 'should emit the appropriate element for an INDI node' do
      GedcomNode.new('@I1@', 'INDI').closing_tag.should == '</indi>'
    end

    it 'should emit the appropriate element for a NAME node' do
      GedcomNode.new('NAME', 'Jamis Gordon /Buck/').closing_tag.should == '</name>'
    end

    it 'should emit the appropriate element for any other node' do
      GedcomNode.new('GIVN', 'Jamis Gordon').closing_tag.should == '</givn>'
    end
  end
end

describe Tree do
  let(:tree) { Tree.new }
  let(:root) { GedcomNode.new('@I1@', 'INDI') }
  let(:child_1) { GedcomNode.new('GIVN', 'Jamis Gordon') }
  let(:child_2) { GedcomNode.new('NAME', 'Jamis Gordon /Buck/') }

  describe '#add_node' do
    it 'should accept a node as an argument' do
      tree.add_node(root)
    end

    it 'should add a node as a child tree if theres already a root' do
      tree.add_node(root)
      tree.add_node(child_1)
      tree.add_node(child_2)

      child_tree_1 = Tree.new.add_node(child_1)
      child_tree_2 = Tree.new.add_node(child_2)

      tree.root.should == root
      tree.children.should == [ child_tree_1, child_tree_2 ]
    end
  end

  describe '#find_child' do
    it 'should return the tree if it exists, null otherwise' do
      tree.add_node(root)

      tree.find_child(root).should == tree
      tree.find_child(child_2).should == nil
    end
  end
end

describe Gedcom do
  let(:gedcom_data) { <<GEDCOM_DATA
0 @I1@ INDI
1 NAME Jamis Gordon /Buck/
2 SURN Buck
2 GIVN Jamis Gordon
1 SEX M
GEDCOM_DATA
  }

  describe '#new' do
    it 'should accept GEDCOM formatted input' do
      Gedcom.new(gedcom_data)
    end
  end

  describe '#to_xml' do 
    it 'should output the GEDCOM data as XML' do 
      Gedcom.new(gedcom_data).to_xml.should == <<XML
<gedcom>
  <indi id="@I1@">
    <name value="Jamis Gordon /Buck/">
      <surn>Buck</surn>
      <givn>Jamis Gordon</givn>
    </name>
    <sex>M</sex>
  </indi>
</gedcom>
XML
    end
  end
end
