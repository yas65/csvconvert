#require "rubygems"
#require "bundler"
require "csv"
require File.join(File.dirname(__FILE__),"risona_bank_format.rb")
#Bundler.setup

class Csvconvert
  attr_accessor :filename 
  def initialize(filename)
    @filename = filename
    @strategy = RisonaBankFormat.new
  end
  def run
    inf = CSV.open(@filename,'r')
    outf = CSV.open(File.join(File.dirname(@filename),'output_' + File.basename(@filename)),'w')
    rows = @strategy.convert(inf)
    rows.each do |row|
      outf << row
    end
    inf.close
    outf.close
    "complete!"
  end
end

