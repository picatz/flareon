RSpec.describe Flareon do
  it "has a version number" do
    expect(Flareon::VERSION).not_to be nil
  end

  it "can resolve google.com" do
    resp = Flareon.resolve?("google.com")
    expect(resp).to eq(true)
  end
end
