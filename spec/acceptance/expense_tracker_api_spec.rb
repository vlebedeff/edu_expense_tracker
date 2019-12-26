require 'rack/test'
require 'json'
require 'app/api'
require 'spec/support/web'

module ExpenseTracker
  RSpec.describe 'Expense Tracker API', :db do
    include Rack::Test::Methods
    include Support::Web

    def app
      ExpenseTracker::API.new
    end

    def post_expense(expense)
      post '/expenses', JSON.generate(expense)
      expect(last_response.status).to eq(200)

      expect(last_json_response).to include('expense_id' => a_kind_of(Integer))

      expense.merge('id' => last_json_response['expense_id'])
    end

    it 'records submitted expenses' do
      coffee = post_expense(
        'vendor' => 'Starbucks',
        'amount' => 5.75,
        'date' => '2017-06-10'
      )

      zoo = post_expense(
        'vendor' => 'Zoo',
        'amount' => 15.25,
        'date' => '2017-06-10'
      )

      groceries = post_expense(
        'vendor' => 'Whole Foods',
        'amount' => 95.20,
        'date' => '2017-06-11'
      )

      get '/expenses/2017-06-10'
      expect(last_response.status).to eq(200)

      expect(last_json_response).to contain_exactly(coffee, zoo)
    end
  end
end
