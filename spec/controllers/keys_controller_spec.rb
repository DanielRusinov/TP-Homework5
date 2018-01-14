RSpec.describe KeysController, :type => :controller do

	describe "spec for getting a key" do
		it "gets a key by id" do
			get :show, params:{id: 1}
			expect(response.body).to eq("{\"n\":4399,\"e\":1433,\"d\":61}")
		end
	end

	describe "specs for creating a key" do
		it "creates a key (without aruments) and checks if it exist in the database" do
			post :new
			expect(Key.where(id: JSON.parse(response.body)["id"])).to exist
		end
	
		it "creates a key (with aruments) and checks if it exist in the database" do
			post :new, params: {n: 19, e: 14, d: 48}
			key = Key.find_by_id(JSON.parse(response.body)["id"])
			expect(key.n).to eq(19)
			expect(key.e).to eq(14)
			expect(key.d).to eq(48)
		end
	end
end
