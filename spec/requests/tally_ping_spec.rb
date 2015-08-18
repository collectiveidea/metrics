describe "Tally Ping" do
  let!(:tally) do
    create(:tally,
      pattern: '^((?<user>[^ ]+) )?swore( (?<howbad>badly))?( (?<number>\d+(\.\d+)?) times)?$'
    )
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

  it "accepts decimal numbers" do
    expect {
      post "/slack", text: "swore 1.5 times", user_name: "steve"
    }.to change {
      DataPoint.count
    }.from(0).to(1)

    data_point = DataPoint.last
    expect(data_point.metric).to eq(tally)
    expect(data_point.number).to eq(1.5)
    expect(data_point.user).to eq("steve")
  end

  it "saves custom data outside of number and user" do
    expect {
      post "/slack", text: "swore badly", user_name: "steve"
    }.to change {
      DataPoint.count
    }.from(0).to(1)

    data_point = DataPoint.last
    expect(data_point.metric).to eq(tally)
    expect(data_point.number).to eq(1)
    expect(data_point.user).to eq("steve")
    expect(data_point.data["howbad"]).to eq("badly")
  end
end
