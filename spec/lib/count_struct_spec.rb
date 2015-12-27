
require "count_struct"

describe CountStruct do
  it "generally works" do
    expect {described_class.new}.to raise_error(ArgumentError, "At least one key is required")
    expect {described_class.new(:a, :total)}.to raise_error(ArgumentError, "Key 'total' is not allowed")

    r = described_class.new(:cats, :dogs).new
    expect(r.cats).to eq 0
    r.cats = 1
    r.dogs = 3
    expect(r.to_h).to eq({cats: 1, dogs: 3, total: 4})
    r.dogs += 1
    expect(r.to_h).to eq({cats: 1, dogs: 4, total: 5})
    expect(r.inspect).to eq "#<count cats=1 dogs=4 | total=5>"
    r.clear
    expect(r.to_h).to eq({cats: 0, dogs: 0, total: 0})

    # Uneven values.
    r = described_class.new(:points_a, :points_b).new
    r.points_a = 0.1
    r.points_b = 0.2
    expect(r.to_h).to eq({points_a: 0.1, points_b: 0.2, total: 0.1 + 0.2})

    # Half-special keywords like `in`.
    r = described_class.new(:class, :def, :for, :in).new
    r.class = 1
    r.def = 1
    r.for = 1
    r.in = 1
    expect(r.to_h).to eq({class: 1, def: 1, for: 1, in: 1, total: 4})
    expect(r.inspect).to eq "#<count class=1 def=1 for=1 in=1 | total=4>"
  end
end

describe CountStruct::NoTotal do
  it "generally works" do
    expect {described_class.new}.to raise_error(ArgumentError, "At least one key is required")
    expect {described_class.new(:a, :total)}.to raise_error(ArgumentError, "Key 'total' is not allowed")

    r = described_class.new(:cats, :dogs).new
    expect(r.cats).to eq 0
    r.cats = 1
    r.dogs = 3
    expect(r.to_h).to eq({cats: 1, dogs: 3})
    r.dogs += 1
    expect(r.to_h).to eq({cats: 1, dogs: 4})
    expect(r.inspect).to eq "#<count cats=1 dogs=4>"
    r.clear
    expect(r.to_h).to eq({cats: 0, dogs: 0})

    # Uneven values.
    r = described_class.new(:points_a, :points_b).new
    r.points_a = 0.1
    r.points_b = 0.2
    expect(r.to_h).to eq({points_a: 0.1, points_b: 0.2})

    # Half-special keywords like `in`.
    r = described_class.new(:class, :def, :for, :in).new
    r.class = 1
    r.def = 1
    r.for = 1
    r.in = 1
    expect(r.to_h).to eq({class: 1, def: 1, for: 1, in: 1})
    expect(r.inspect).to eq "#<count class=1 def=1 for=1 in=1>"
  end
end
