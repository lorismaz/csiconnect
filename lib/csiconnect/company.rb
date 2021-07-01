module Csiconnect
  class Company
    
    class << self
      
      # https://api.docs.globalvcard.com/reference#list-companies
      def list(params = {})
        raise 'token is missing' unless params[:token]
        response = Csiconnect.request(:get, "v2/companies", params)
      end
      
      # https://api.docs.globalvcard.com/reference#show-company-detaile
      def retrieve_balance(company_id, params = {})
        raise 'token is missing' unless params[:token]
        raise 'company_id is missing' unless company_id
        response = Csiconnect.request(:get, "v2/companies/#{company_id}", params)
        response['moduleConfigurations']['comdata']['availableBalance'] rescue 0.00
      end

    end
  end
end