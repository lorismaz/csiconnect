module Csiconnect
  class Token
    
    class << self
      # https://api.docs.globalvcard.com/reference#create-a-token
      def create(params = {})
        response = Csiconnect.request(:post, "v2/tokens", params)
        return response
      end
      
      # https://api.docs.globalvcard.com/reference#show-all-tokens
      def list_all(params = {})
        raise 'token is missing' unless params[:token]
        response = Csiconnect.request(:get, "v2/tokens", params)
      end

    end
  end
end