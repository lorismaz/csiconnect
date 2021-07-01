# frozen_string_literal: true

require 'rest-client'

require 'csiconnect/token'
require 'csiconnect/company'
require 'csiconnect/virtual_card'

module Csiconnect
  class CsiconnectError < StandardError
  end

  class AuthenticationError < CsiconnectError;
  end
  class ConfigurationError < CsiconnectError;
  end
  class ApiRequestError < CsiconnectError
    attr_reader :response_code, :response_headers, :response_body

    def initialize(response_code:, response_headers:, response_body:)
      @response_code = response_code
      @response_headers = response_headers
      @response_body = response_body
    end
  end

  class << self
    def api_base_url
      defined? @api_base_url and @api_base_url or raise(
        ConfigurationError, "CSI Paysystems api_bsae_url not configured"
      )
    end

    attr_writer :api_base_url

    def username
      defined? @username and @username or raise(
        ConfigurationError, "CSI Paysystems username not configured"
      )
    end

    attr_writer :username

    def password
      defined? @password and @password or raise(
        ConfigurationError, "CSI Paysystems password not configured"
      )
    end

    attr_writer :password

    def request method, resource, params = {}
      api_base_url = params[:api_base_url] || Csiconnect.api_base_url
      cc_username = params[:username] || Csiconnect.username
      cc_password = params[:password] || Csiconnect.password
      auth_token = params[:token]

      params.reject{|k,v| ['api_base_url', 'username', 'password', 'token'].include?(k.to_s)} if params != {}

      defined? method or raise(
        ArgumentError, "Request method has not been specified"
      )
      defined? resource or raise(
        ArgumentError, "Request resource has not been specified"
      )
      if method == :get
        headers = {accept: :json, content_type: :json}.merge({params: params})
        payload = nil
      else
        headers = {accept: :json, content_type: :json}
        if method == :post && resource == 'v2/tokens'
          payload = {
            username: cc_username,
            password: cc_password
        }
        else
          payload = params
        end
      end

      if auth_token
        headers = headers.merge(AUTH: auth_token)
      end

      json_payload = payload.to_json if payload
        
      RestClient::Request.new({
        method: method, 
        url: "#{api_base_url}/#{resource}", 
        headers: headers, 
        payload: json_payload
      }).execute do |response, request, result|
        JSON.parse(response.to_str) if response
      end

    end

    def datetime_format datetime
      datetime.strftime("%Y-%m-%d %T")
    end
  end
end
