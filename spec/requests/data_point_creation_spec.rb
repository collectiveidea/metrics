describe "Data Point Creation" do
  let!(:metric) { create(:metric, pattern: '^((?<user>[^ ]+) )?swore( (?<howbad>badly))?( (?<number>\d+(\.\d+)?) times)?$') }
  let!(:user) { create(:user, slack_id: "123", slack_name: "steve") }

  it "creates a data point for the matching metric" do
    expect {
      post "/slack",
        text: "swore",
        user_id: user.slack_id,
        user_name: user.slack_name
    }.to change {
      DataPoint.count
    }.from(0).to(1)

    expect(response.status).to eq(201)
    expect(response.body).to be_present

    data_point = DataPoint.last
    expect(data_point.metric).to eq(metric)
    expect(data_point.user).to eq(user)
    expect(data_point.number).to eq(1)
  end

  it "creates a data point with a different number" do
    expect {
      post "/slack",
        text: "swore 2 times",
        user_id: user.slack_id,
        user_name: user.slack_name
    }.to change {
      DataPoint.count
    }.from(0).to(1)

    data_point = DataPoint.last
    expect(data_point.metric).to eq(metric)
    expect(data_point.user).to eq(user)
    expect(data_point.number).to eq(2)
  end

  it "creates a data point with a different user" do
    expect {
      post "/slack",
        text: "brian swore",
        user_id: user.slack_id,
        user_name: user.slack_name
    }.to change {
      DataPoint.count
    }.from(0).to(1)

    data_point = DataPoint.last
    expect(data_point.metric).to eq(metric)
    expect(data_point.user).to eq(user) # brian
    expect(data_point.number).to eq(1)
  end

  it "creates a data point with a different number and user" do
    expect {
      post "/slack",
        text: "brian swore 2 times",
        user_id: user.slack_id,
        user_name: user.slack_name
    }.to change {
      DataPoint.count
    }.from(0).to(1)

    data_point = DataPoint.last
    expect(data_point.metric).to eq(metric)
    expect(data_point.user).to eq(user) # brian
    expect(data_point.number).to eq(2)
  end

  it "accepts decimal numbers" do
    expect {
      post "/slack",
        text: "swore 1.5 times",
        user_id: user.slack_id,
        user_name: user.slack_name
    }.to change {
      DataPoint.count
    }.from(0).to(1)

    data_point = DataPoint.last
    expect(data_point.metric).to eq(metric)
    expect(data_point.user).to eq(user)
    expect(data_point.number).to eq(1.5)
  end

  it "saves custom data outside of number and user" do
    expect {
      post "/slack",
        text: "swore badly",
        user_id: user.slack_id,
        user_name: user.slack_name
    }.to change {
      DataPoint.count
    }.from(0).to(1)

    data_point = DataPoint.last
    expect(data_point.metric).to eq(metric)
    expect(data_point.user).to eq(user)
    expect(data_point.number).to eq(1)
    expect(data_point.data["howbad"]).to eq("badly")
  end

  it "bombs if the text matches no metric" do
    expect {
      post "/slack",
        text: "sw0re",
        user_id: user.slack_id,
        user_name: user.slack_name
    }.not_to change {
      DataPoint.count
    }

    expect(response.status).to eq(422)
    expect(response.body).to be_present
  end

  it "bombs if the text matches multiple metrics" do
    create(:metric, pattern: "wore")

    expect {
      post "/slack",
        text: "swore",
        user_id: user.slack_id,
        user_name: user.slack_name
    }.not_to change {
      DataPoint.count
    }

    expect(response.status).to eq(409)
    expect(response.body).to be_present
  end
end
