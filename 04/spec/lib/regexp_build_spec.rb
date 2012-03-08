require 'spec_helper'

describe Regexp do
  describe '#build' do
    it 'should accept any number of Integers and return a Regexp object' do
      lucky  = Regexp.build(3, 7)

      ("7"  =~ lucky).should be_true
      ("13" =~ lucky).should be_false
      ("3"  =~ lucky).should be_true
    end

    it 'should accept a Range and return a Regexp object' do 
      month = Regexp.build(1..12)

      ("0"  =~ month).should be_false
      ("1"  =~ month).should be_true
      ("12" =~ month).should be_true
    end

    it 'should accept a combination of Integers and Ranges' do 
      year = Regexp.build( 98, 99, 2000..2005 )

      ("04"   =~ year).should be_false
      ("2004" =~ year).should be_true
      ("99"   =~ year).should be_true
    end

    it 'should take sign into account' do 
      num = Regexp.build( 0..1_000_000 )

      ("-1" =~ num).should be_false
    end

    it 'should ignore leading zeros' do
      military_time = Regexp.build(1..24)

      ('08' =~ military_time).should be_true
      ('8' =~ military_time).should be_true
    end

    it 'should raise an exception if you give it non int or non range arguments' do 
      lambda { Regexp.build(3, 'seven') }.should raise_exception(ArgumentError, 'Arguments must all be of type Integer or Range')
    end
  end
end
