require 'prime'

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

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

			return [n, e, d]

	   	end
	   
		def encrypt message
			return (message.chars.map {|m| m.ord ** @public %  @common }).join(',')
		end
		   
		def decrypt message
			return (message.split(",").map {|m| (m.to_i ** @private %  @common).chr }).join('')
		end
	end
end
