require 'spec_helper'

describe Vexile do

  before(:all) do
    class A
      include Vexile::DSL
      attr_accessor :p1, :p2
    end
    
    class B
      include Vexile::DSL
      attr_accessor :p3, :p4
      validates :p4, :format => /^test\d+$/
    end

    class C
      include Vexile::DSL
      attr_accessor :p5, :p6
      validates :bs, :size => {:min => 1, :max => 2}, :recursive => true
      has_many :bs
      has_one :a
    end

    class Test
      include Vexile::DSL
      has_many :as, :bs
      has_one :c
      validates :c, :recursive => true
    end

    module Namespaced
      class C
        include Vexile::DSL
        attr_accessor :t
      end
      class Test2
        include Vexile::DSL
        has_one :c
      end
    end
  end


  it "should add attributes method" do
    t = Test.new
    t.c = {:p5 => 1, :p6 => 2, :bs => [{:p3 => "test1", :p4 => "test2"}]}
    t.c.p5.should == 1
    t.c.p6.should == 2
    t.c.bs.first.p3.should == "test1"
    t.c.bs.first.p4.should == "test2"
  end

  it "should run validations correctly" do
    t = Test.new
    t.c = {:p5 => 1, :p6 => 2, :bs => [{:p3 => "test1", :p4 => "testfghgfh"}, {:p3 => "test3", :p4 => "testgsdfgdsf"}]}
    t.c.valid?.should be_false
  end

  it "should raise an exception when initialization is incorrect" do
    t = Test.new
    expect do
      t.c = {:p5 => 1, :p6 => 2, :bs => [{:p3 => "test1", :p4 => "test2"}].to_json}
    end.to raise_error
  end

  it "should validates every element with array attributes" do
    t = Test.new
    t.c = {:p5 => 1, :p6 => 2, :bs => [{:p3 => "test1", :p4 => "test2"},{:p3 => "test1", :p4 => "tfds"}]}
    t.valid?.should be_false
    t.c = {:p5 => 1, :p6 => 2, :bs => [{:p3 => "test1", :p4 => "test2"},{:p3 => "test1", :p4 => "test2"}]}
    t.valid?.should be_true
  end

  it "should correctly resolve vexile classes namespaces" do
    t  = Namespaced::Test2.new
    expect do
      t.c = {:t => "some_value"}
    end.to_not raise_error
    t.c.class.should == Namespaced::C
  end

  it "should save original loaded part" do
    t = Test.new
    t.c = {:p5 => 1, :p6 => 2, :bs => [{:p3 => "test1", :p4 => "test2"}]}
    t.c.__source__.should == {:p5 => 1, :p6 => 2, :bs => [{:p3 => "test1", :p4 => "test2"}]}
    t.c.bs.first.__source__.should == {:p3 => "test1", :p4 => "test2"}
  end

  it "should not raise NoMethodError while non-hash object loaded (just not initialize attribs)" do
    t = Test.new
    expect{ t.c = "test" }.to_not raise_error
    expect{ t.valid? }.to_not raise_error
    expect{ t.c = {:p5 => 1, :p6 => 2, :a => "test"} }.to_not raise_error
    t.c.__source__.should == {:p5 => 1, :p6 => 2, :a => "test"}
    t.c.a.__source__.should == "test"
  end
end