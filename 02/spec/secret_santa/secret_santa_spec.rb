require 'spec_helper'

describe SecretSanta do
  before(:each) do
    @mom1 = Person.new('Mom Curtiss <mom1@fakemail.net>')
    @dad1 = Person.new('Dad Curtiss <dad1@fakemail.net>')
    @chum = Person.new('Chum Chandler <chum@fakemail.net>')
    @mom2 = Person.new('Mom Keen <mom2@fakemail.net>')
    @dad2 = Person.new('Dad Keen <dad2@fakemail.net>')
  end

  describe '#initialize' do
    it 'should reject only one person' do
      lambda { SecretSanta.new([ @mom1 ]) }.should raise_exception(ArgumentError, 'You need at least two people to have a secret santa')
    end

    it 'should recognize unusable combinations' do
      lambda { SecretSanta.new([ @mom1, @dad1, @chum ]) }.should raise_exception(ArgumentError, 'The Curtiss family has too many members - over 50% of the group (2/3)')
    end
  end

  describe '#assign_santas' do
    it 'should assign a secret santa to each user' do
      s = SecretSanta.new([ @mom1, @chum ])

      s.assign_santas.should == {
        @mom1 => @chum,
        @chum => @mom1,
      }
    end

    it 'should not allow the same person to be a recipient more than once' do
      s = SecretSanta.new([ @mom1, @chum, @dad2 ])
      #sorts to @chum @mom1 @dad2 

      s.assign_santas.should == {
        @chum => @mom1,
        @mom1 => @dad2,
        @dad2 => @chum,
      }
    end

    it 'should not assign family members to one another' do
      s = SecretSanta.new([ @mom1, @chum, @dad2, @dad1 ])
      #sorts to @chum @dad1 @mom1 @dad2

      s.assign_santas.should == {
        @chum => @dad1,
        @dad1 => @dad2,
        @mom1 => @chum,
        @dad2 => @mom1,
      }
    end

    it 'should handle multiple families' do
      s = SecretSanta.new([ @mom1, @chum, @dad2, @dad1, @mom2, ])
      #sorts to @chum @dad1 @mom1 @dad2 @mom2
      s.assign_santas.should == {
        @chum => @dad1,
        @dad1 => @dad2,
        @mom1 => @mom2,
        @dad2 => @chum,
        @mom2 => @mom1,
      }
    end
  end

  describe '#notify_santas' do
    it 'should eMail each santa and tell them who their recipient is' do
      s = SecretSanta.new([ @dad1, @dad2 ])
      s.assign_santas
      s.notify_santas
    end
  end
end
