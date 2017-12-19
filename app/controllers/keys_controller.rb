require 'prime'

class KeysController < ApplicationController
  before_action :set_key, only: [:show, :edit, :update, :destroy]


  def index
    @keys = Key.all
  end


  def show
	key = Key.find_by id: params[:id]
	render json: {'n' => key.n , 'e' => key.e, 'd' => key.d}
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


  def edit
  end


  def create
    @key = Key.new(key_params)

    respond_to do |format|
      if @key.save
        format.html { redirect_to @key, notice: 'Key was successfully created.' }
        format.json { render :show, status: :created, location: @key }
      else
        format.html { render :new }
        format.json { render json: @key.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_key
      @key = Key.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def key_params
      params.require(:key).permit(:n, :e, :d)
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


end
