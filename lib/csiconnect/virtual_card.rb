module Csiconnect
  class VirtualCard
    
    class << self
      # https://api.docs.globalvcard.com/reference#create-a-card
      def create(params = {})
        raise 'token is missing' unless params[:token]
        raise 'amount is missing' unless params[:amount]
        raise 'exactAmount is missing' unless params[:exactAmount]
        raise 'firstName is missing' unless params[:firstName]
        raise 'lastName is missing' unless params[:lastName]
        raise 'expirationMonth is missing' unless params[:expirationMonth]
        raise 'expirationYear is missing' unless params[:expirationYear]
        response = Csiconnect.request(:post, "v2/virtualCards", params)
        return response
      end
      
    end
  end
end