require 'spec_helper'

describe Person do

  before(:each) do
    @moms = Person.new('Moms Curtiss <moms@fakemail.net>')
    @mark = Person.new('Mark Curtiss <mark@fakemail.net>')
    @pete = Person.new('Pete Keen <pete@fakemail.net>')
  end

  describe '#initialize' do
    it 'should initialize first and last name and eMail_address address from the input string' do
      @mark.first_name.should eql 'Mark'
      @mark.last_name.should eql 'Curtiss'
      @mark.eMail_address.should eql 'mark@fakemail.net'
    end
  end

  describe '#is_related_to?' do
    it 'should return true if people have the same last name' do
      @moms.is_related_to?(@mark).should be_true
      @moms.is_related_to?(@pete).should be_false
    end
  end

  it 'should sort by last name then first name' do
    [ @moms, @pete, @mark ].sort.should == [ @mark, @moms, @pete ]
  end


end
