require 'spec_helper'
require 'liquid/filters/currency_filters.rb'

# Specs in this file have access to a helper object that includes
# the DlHelper. For example:
#
# describe DlHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
describe "CurrencyFilters" do
  it "format currency into JPY" do
    expect(::Liquid::Template.parse("{{price|currency :'JPY'}}").render('price' => '100000')).to eq('10万')
    expect(::Liquid::Template.parse("{{price|currency :'JPY'}}").render('price' => '100')).to eq('100')
    expect(::Liquid::Template.parse("{{price|currency :'JPY'}}").render('price' => '100100')).to eq('10万100')
    expect(::Liquid::Template.parse("{{price|currency :'JPY'}}").render('price' => '901100')).to eq('90万1100')
    expect(::Liquid::Template.parse("{{price|currency}}").render('price' => '901100')).to eq('901100')
  end
end
