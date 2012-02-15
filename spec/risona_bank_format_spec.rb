require "spec_helper"
require "csv"
describe "RisonaBankFormat" do
  it "should convert columns" do
    stg = RisonaBankFormat.new
    inf = CSV.open(File.join(File.dirname(__FILE__),'sample','risona.csv'),'r')
    outputs = stg.convert(inf)
    outputs.size.should == 2
    outputs.each do |output|
      p output
    end
  end
end