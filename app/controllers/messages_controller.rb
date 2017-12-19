require "./keys_controller.rb"
class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  def show
		message = Message.find_by id: params[:id], rsaid: params[:messageid]
		render json: {message: message.content}
  end

	def encrypt
		rsa = Key.find_by id: params[:id]
		rsa_ = RSA.new(rsa.n, rsa.e, rsa.d)
    encrypted_message = rsa_.encrypt(params[:message])
    message = Message.new({content: encrypted_message})

    if message.save
      render json: {id: message.id}
    end

	end

	def decrypt
		rsa = Key.find_by id: params[:id]
    rsa_ = RSA.new(rsa.n, rsa.e, rsa.d)
    decrypted_message = rsa_.decrypt(params[:message])
    
		render json: {message: decrypted_message}

	end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:id, :content)
    end
end
