describe "Tally Ping" do
  let!(:tally) do
    create(:tally, pattern: "((?<user>[^ ]+) )?swore( (?<number>\d+) times)?")
  end

  it "creates a data point for the matching tally" do
    expect {
      post "/slack", text: "swore", user_name: "steve"
    }.to change {
      DataPoint.count
    }.by(1)

    data_point = DataPoint.last
    expect(data_point.metric).to eq(tally)
    expect(data_point.number).to eq(1)
    expect(data_point.user).to eq("steve")
  end
end
