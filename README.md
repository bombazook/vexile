# Vexile

Simple dsl for multilevel hash validations

---

[![Build Status](https://travis-ci.org/bombazook/vexile.png)](https://travis-ci.org/bombazook/vexile)

Tested on:
  - 2.0.0
  - 1.9.3
  - 1.9.2
  - 1.8.7
  - ree
  - jruby-head
  - jruby-18mode
  - jruby-19mode
  - rbx-18mode
  - rbx-19mode

## Installation

Add this line to your application's Gemfile:

    gem 'vexile'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vexile

## Usage

Just declare some classes using such DSL:

    class A
      include Vexile::DSL
    end

    class B
      include Vexile::DSL
    end

    class C
      include Vexile::DSL
    end
    
and then, if you have deep level hashes something like {"a": {"b":{"param1":"value1"}, "cs": [{"param2":2}, {"param2": 3}]}}}
and if you know it's structure, you can modify classes somehow like that:

    class A
      include Vexile::DSL
      has_one :b
      has_many :cs
    end

    class B
      include Vexile::DSL
      attr_accessor :param1
    end

    class C
      include Vexile::DSL
      attr_accessor :param2
    end

then create instance of top level class and load hash to it:
    
    a = A.new
    a.load_params({"b"=>{"param1"=>"value1"}, "cs"=> [{"param2"=>"atata"}, {"param2"=> 3}]})
    
Now you have an instances tree initialized:

    a.b # => <B ... @param1="value1" ... >
    a.cs # => [#<C ... @param2=2 ...>, #<C ... @param2=3 ...>] 

So you can also add activemodel validations:

    class A
      include Vexile::DSL
      has_one :b
      has_many :cs
      validates :cs, :recursive => true # validator that checks any loaded C instance
    end

    class B
      include Vexile::DSL
      attr_accessor :param1
      validates :param1, :numericality => true
    end

    class C
      include Vexile::DSL
      attr_accessor :param2
      validates :param2, :numericality => true
    end
    
So

    a.valid? # => false # 
    
because of NumericalityValidator added

    a.errors # => ...  @messages={:cs=>["is invalid in #<C:0x007f94729ade28> : {:param2=>[\"is not a number\"]}"...
    
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
