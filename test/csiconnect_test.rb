require 'minitest/autorun'
require 'webmock/minitest'
require 'csiconnect'
require 'byebug'

WebMock.disable_net_connect!(allow_localhost: true)

class CsiconnectTest < Minitest::Test
  def setup
    @params = {}
    Csiconnect.api_base_url = 'https://example.com'
    @params[:username] = 'username'
    @params[:password] = 'password'
    Csiconnect.username = @params[:username]
    Csiconnect.password = @params[:password]
    stub_request(:post, /tokens/).to_return body: { token: 'token' }.to_json
    @token_create_response = Csiconnect::Token.create(@params)
    @token = @token_create_response['token']
  end

  def test_token_create
    assert_instance_of(String, @token)
    assert_equal(@token, 'token')
  end

  def test_company_list
    stub_request(:get, /companies/).to_return body: [
                                               {
                                                 'accountCode' => 'AC123',
                                                 'address1' => nil,
                                                 'address2' => nil,
                                                 'adminId' => 12_345,
                                                 'businessCategory' => nil,
                                                 'businessDescription' => nil,
                                                 'city' => nil,
                                                 'configs' => {},
                                                 'countryCode' => 'US',
                                                 'customerId' => 'C1234',
                                                 'id' => 1234,
                                                 'masterVendorRecordId' => nil,
                                                 'name' => 'foo',
                                                 'phone' => nil,
                                                 'state' => nil,
                                                 'zip' => nil,
                                               },
                                             ].to_json
    response = Csiconnect::Company.list(token: @token)
    assert_instance_of(Array, response)
    assert_equal response[0]['name'], 'foo'
  end

  def test_company_retrieve_balance
    company_id = 1234
    stub_request(:get, %r{companies\/1234}).to_return body: {
                                                       'moduleConfigurations' => {
                                                         'comdata' => {
                                                           'availableBalance' =>
                                                             1234,
                                                         },
                                                       },
                                                     }.to_json
    balance = Csiconnect::Company.retrieve_balance(company_id, token: @token)
    assert_equal balance, 1234
  end

  def test_virtual_card_create
    stub_request(:post, /virtualCards/).to_return body: {
                                                   'acceptedMerchants' => [],
                                                   'amount' => 1.23,
                                                   'availableBalance' => 0,
                                                   'blocked' => false,
                                                   'cardNumber' =>
                                                     '0123456789',
                                                   'config' => {
                                                     'placeHolder' => nil,
                                                   },
                                                   'created' =>
                                                     '2021-01-01T00:00:00Z',
                                                   'cvc2' => '123',
                                                   'exactAmount' => true,
                                                   'expirationMMYY' => '0125',
                                                   'externalToken' =>
                                                     '9876543210',
                                                   'firstName' => 'John',
                                                   'id' => 1_234_567,
                                                   'invoiceNumber' => nil,
                                                   'lastFour' => '0123',
                                                   'lastName' => 'Smith',
                                                   'notes' => nil,
                                                   'numberOfTransactions' => 1,
                                                   'poNumber' => nil,
                                                   'usageTypes' => [
                                                     'Car rentals',
                                                     'Restaurants',
                                                     'Business',
                                                     'Maintenance',
                                                     'Financial',
                                                     'Airline',
                                                     'Hotels',
                                                     'Medical',
                                                     'Miscellaneous',
                                                     'Fuel',
                                                     'Legal/Ins.',
                                                     'Misc. Transport',
                                                   ],
                                                 }.to_json
    params = {
      amount: 1.23,
      exactAmount: true,
      numberOfTransactions: 1,
      firstName: 'John',
      lastName: 'Smith',
      expirationMonth: 1,
      expirationYear: 2025,
      token: '9876543210',
    }
    response = Csiconnect::VirtualCard.create(params)
    assert_equal response['cardNumber'], '0123456789'
  end
end
