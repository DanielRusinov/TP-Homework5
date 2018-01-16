class MessagesController < ApplicationController

	def show
		message = Message.find_by id: params[:messageid]
		render json: {message: message.content}
	end

	def encrypt
		rsa = Key.find_by_id(params[:id])
		rsa_ = RSA.new(rsa.n, rsa.e, rsa.d)
		encrypted_message = rsa_.encrypt(params[:message])
		message = Message.new({content: encrypted_message})

		if message.save
			render json: {id: message.id}
		end

	end

	def decrypt
		rsa = Key.find_by_id(params[:id])
		rsa_ = RSA.new(rsa.n, rsa.e, rsa.d)
		decrypted_message = rsa_.decrypt(params[:message])
    
		render json: {message: decrypted_message}

	end

private
  
	def set_message
		@message = Message.find(params[:id])
	end

	def message_params
		params.require(:message).permit(:id, :content)
	end

end
