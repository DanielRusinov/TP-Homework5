RSpec.describe MessagesController, :type => :controller do

	describe "spec for getting a message" do
		it "gets encrypted message by id" do
			get :show, params:{id: 1, messageid: 1}
			expect(response.body).to eq("{\"message\":\"3589,5426,3589,6967,3589,5426,3589\"}")
		end
	end

	describe "specs for encrypting and decrypting a message" do
		it "checks if the encrypting works" do
			post :encrypt, params: {id: 1, message: "azsymdani"}
			message = Message.find_by_id(JSON.parse(response.body)["id"])
			expect(message.content).to eq("1126,3778,2902,3481,1086,2434,1126,3509,4239")
		end

		it "checks if the decrypting works properly, using the message from the previous spec" do
			post :decrypt, params: {id: 1, message: "1126,3778,2902,3481,1086,2434,1126,3509,4239"}
			expect(JSON.parse(response.body)["message"]).to eq("azsymdani")
		end
	end
end
