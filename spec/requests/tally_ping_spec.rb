describe "Tally Ping" do
  let!(:tally) do
    create(:tally, pattern: '^((?<user>[^ ]+) )?swore( (?<number>\d+) times)?$')
  end

  it "creates a data point for the matching tally" do
    expect {
      post "/slack", text: "swore", user_name: "steve"
    }.to change {
      DataPoint.count
    }.from(0).to(1)

    data_point = DataPoint.last
    expect(data_point.metric).to eq(tally)
    expect(data_point.number).to eq(1)
    expect(data_point.user).to eq("steve")
  end

  it "creates a data point with a different number" do
    expect {
      post "/slack", text: "swore 2 times", user_name: "steve"
    }.to change {
      DataPoint.count
    }.from(0).to(1)

    data_point = DataPoint.last
    expect(data_point.metric).to eq(tally)
    expect(data_point.number).to eq(2)
    expect(data_point.user).to eq("steve")
  end

  it "creates a data point with a different user" do
    expect {
      post "/slack", text: "brian swore", user_name: "steve"
    }.to change {
      DataPoint.count
    }.from(0).to(1)

    data_point = DataPoint.last
    expect(data_point.metric).to eq(tally)
    expect(data_point.number).to eq(1)
    expect(data_point.user).to eq("brian")
  end

  it "creates a data point with a different number and user" do
    expect {
      post "/slack", text: "brian swore 2 times", user_name: "steve"
    }.to change {
      DataPoint.count
    }.from(0).to(1)

    data_point = DataPoint.last
    expect(data_point.metric).to eq(tally)
    expect(data_point.number).to eq(2)
    expect(data_point.user).to eq("brian")
  end
end
