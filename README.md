# csi-connect-rails

A ruby gem to interact with CSI Connect / GlobalVCard virtual card system

[Release Notes](https://github.com/lorismaz/)

## Installation

Add module to your Gemfile:

```ruby
gem 'csiconnect'
```

Then run bundle to install the Gem:

```sh
bundle install
```

Set up an initializer file with your CSI Connect / GlobalVCard virtual card system Base URL, username, password:

```ruby
Csiconnect.api_base_url = 'https://partners.gvcdemo.com'
Csiconnect.username  = 'CSI Paysystems username'
Csiconnect.password  = 'CSI Paysystems password'
```
e.g. *config/initializers/csiconnect.rb*

## Usage

---

### Create a Token

Create a new authentication token to use access the other end points first!

API doc: https://api.docs.globalvcard.com/reference#create-a-token

```ruby
response = Csiconnect::Token.create
token = response['token']
```

---

### List all tokens
Shows all tokens you have created

API doc: https://api.docs.globalvcard.com/reference#show-all-tokens

```ruby
# params[:token] is mandatory here
tokens_list = Csiconnect::Token.list_all(token: token)
```

---

### List companies
Retrieves a list of companies associated with your AuthToken

API doc: https://api.docs.globalvcard.com/reference#list-companies

```ruby
# params[:token] is mandatory here
companies_list = Csiconnect::Company.list(token: token)
```

---

### Create a Virtual Card
Creates a single virtual card for a specific amount

API doc: https://api.docs.globalvcard.com/reference#create-a-card

```ruby
# params[:token] is mandatory here
# the following params below are mandatory according to the API doc
params = {
  "amount": 5.11,   
  "exactAmount": true,   
  "numberOfTransactions": 2,   
  "firstName": "John",   
  "lastName": "Smith",   
  "expirationMonth": 4,   
  "expirationYear": 2025, 
  "token": token
}
vcard = Csiconnect::VirtualCard.create(params)
```

---

## Copyright
Copyright (c) 2021 [lorismaz](https://github.com/lorismaz), [kevinhq](https://github.com/kevinhq)
Licenced under the MIT licence.
