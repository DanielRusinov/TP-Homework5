class KeysController < ApplicationController

	def show
	key = Key.find_by_id( params[:id] )
	render json: {:n => key.n , :e => key.e, :d => key.d}
	end


	def new
		required_params = [:n, :e, :d]
		if required_params.all? {|c| params.has_key? c}
			rsa = Key.new({n: params[:n], d: params[:d], e: params[:e]})
		else
			keys = RSA.new_key
			rsa = Key.new({n: keys[0], d: keys[2], e: keys[1]}) 
		end

		if rsa.save
		render json: {id: rsa.id}
		end
	end

private
	    
	def set_key
		@key = Key.find(params[:id])
	end

	def key_params
		params.require(:key).permit(:n, :e, :d)
	end

end
