module Csiconnect
  class VirtualCard
    
    class << self

      # https://api.docs.globalvcard.com/reference/show-cards
      def list(params = {})
        raise 'token is missing' unless params[:token]
        response = Csiconnect.request(:get, "v2/virtualCards", params)
        return response
      end

      # https://api.docs.globalvcard.com/reference/show-cards
      def details(id, params = {})
        raise 'token is missing' unless params[:token]
        raise 'card id is missing' unless id
        response = Csiconnect.request(:get, "v2/virtualCards/#{id}", params)
        return response
      end

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

      # https://api.docs.globalvcard.com/reference/block-or-unblock-a-card
      def block(card_id, params = {})
        raise 'token is missing' unless params[:token]
        raise 'card_id is missing' unless card_id
        response = Csiconnect.request(:put, "v2/virtualCards/#{card_id}/block", params)
        return response
      end
      
      # https://api.docs.globalvcard.com/reference/block-a-virtualcard
      def unblock(card_id, params = {})
        raise 'token is missing' unless params[:token]
        raise 'card_id is missing' unless card_id
        response = Csiconnect.request(:put, "v2/virtualCards/#{card_id}/unblock", params)
        return response
      end

      # https://api.docs.globalvcard.com/reference/create-a-card-1
      def update(card_id, params = {})
        raise 'token is missing' unless params[:token]
        raise 'card_id is missing' unless card_id
        raise 'amount is missing' unless params[:amount]
        response = Csiconnect.request(:put, "v2/virtualCards/#{card_id}", params)
        return response
      end
    end
  end
end