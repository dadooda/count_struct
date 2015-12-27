
CountStruct
===========

The Struct for counting

Overview
--------

```ruby
>> require "count_struct"
>> count = CountStruct.new(:cats, :dogs).new
>> count.cats
=> 0
>> count.cats += 1
>> count.dogs += 3
>> count.to_h
=> {:cats=>1, :dogs=>3, :total=>4}
>> count.dogs = 0
>> count.to_h
=> {:cats=>1, :dogs=>0, :total=>1}
```

Using in a class:

```ruby
require "count_struct"

class AnimalReport
  Count = CountStruct.new(:cats, :dogs)      # Use a regular constant for the class. DO NOT use `class Count < ...` due to superclass mismatch error.

  def add_cat(cat)
    count.cats += 1
    ...
  end

  def add_dog(dog)
    count.dogs += 1
    ...
  end

  def count
    @count ||= Count.new
  end
end
```

Full documentation is available at [rubydoc.info](http://www.rubydoc.info/github/dadooda/count_struct/CountStruct).


Setup
-----

This project is a *sub*. Sub setup example is available [here](https://github.com/dadooda/subs#setup).

For more info on subs, click [here](https://github.com/dadooda/subs).


Cheers!
-------

&mdash; Alex Fortuna, &copy; 2015
