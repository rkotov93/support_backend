RSpec.shared_examples 'authentication error' do
  it 'returns authentication error' do
    expect(response.status).to eq 401
  end
end
