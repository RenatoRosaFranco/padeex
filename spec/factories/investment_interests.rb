FactoryBot.define do
  factory :investment_interest do
    first_name { "MyString" }
    last_name { "MyString" }
    email { "MyString" }
    phone { "MyString" }
    investment_range { InvestmentInterest.investment_ranges.first }
    message { "MyText" }
  end
end
