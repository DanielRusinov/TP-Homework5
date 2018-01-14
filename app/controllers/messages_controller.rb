class MessagesController < ApplicationController
  
  #before_action :set_message, only: [:show, :edit, :update, :destroy]

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

class RSA
	def initialize n, e, d
		@common = n
		@public = e
		@private = d
	end
   
	def n
		return @common
	end
   
	def e
		return @public
	end
   
	def d
		return @private
	end
   
	def self.new_key

		p = Random.new.rand(1..99)
		q = Random.new.rand(1..99)

		until Prime.prime?(p) == true do
			p % 2 ? p += 1 : p += 2
		end

		until Prime.prime?(q) == true do
			q % 2 ? q += 1 : q += 2
		end

		n = p * q

		lcm = (p-1).lcm(q-1)

		e = 1
		while true do
			e = Random.new.rand(1..lcm)
			if e.gcd(lcm) == 1
				break
			end
	
		end

		d = 1
		while true do
			if(d * e) %lcm == 1
				break
			end
			d += 1
			
		end

		arr = [n, e, d]
		return arr

   end
   
   def encrypt message
	return (message.chars.map {|m| m.ord ** @public %  @common }).join(',')
   end
   
   def decrypt message
	return (message.split(",").map {|m| (m.to_i ** @private %  @common).chr }).join('')
   end 
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
