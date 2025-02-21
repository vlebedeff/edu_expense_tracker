require 'rack/test'
require 'app/api'
require 'spec/support/web'

module ExpenseTracker
  RSpec.describe API do
    include Rack::Test::Methods
    include Support::Web

    def app
      API.new(ledger: ledger)
    end

    let(:ledger) { instance_double('ExpenseTracker::Ledger') }

    describe 'POST /expenses' do
      context 'when the expense is successfully recorded' do
        let(:expense) { {'some' => 'data'} }

        before do
          allow(ledger).to receive(:record).and_return(RecordResult.new(true, 417, nil))
        end

        it 'returns the expense id' do
          post '/expenses', JSON.generate(expense)

          expect(last_json_response).to include('expense_id' => 417)
        end

        it 'responds with a 200 (OK)' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(200)
        end
      end

      context "when the expense fails validation" do
        let(:expense) { {'some' => 'data'} }

        before do
          allow(ledger).to receive(:record).and_return(
            RecordResult.new(false, 417, 'Expense incomplete')
          )
        end

        it 'returns an error message' do
          post '/expenses', JSON.generate(expense)

          expect(last_json_response).to include('error' => 'Expense incomplete')
        end

        it 'responds with a 422 (Unprocessable entity)' do
          post '/expenses', JSON.generate(expense)
          expect(last_response.status).to eq(422)
        end
      end
    end

    describe 'GET /expenses/:date' do
      context 'when expenses exist on the given date' do
        it 'returns the expense records as JSON'
        it 'responds with a 200 (OK)'
      end

      context "when there are no expenses on the given date" do
        it 'returns empty array as JSON'
        it 'responds with a 200 (OK)'
      end
    end
  end
end
