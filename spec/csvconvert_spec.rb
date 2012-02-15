require "spec_helper"

describe "Csvconvert" do
  SAMPLE_FILE = 'spec/sample/test.csv'
  it "spec check" do
    p File.split(SAMPLE_FILE)
    p File.basename(SAMPLE_FILE)
    p File.dirname(SAMPLE_FILE)
  end
  it "should foo" do
    csv = Csvconvert.new(SAMPLE_FILE)
    csv.run.should == "complete!"
    File.exists?(SAMPLE_FILE.sub("test.csv","output_test.csv")).should be_true
  end
end
