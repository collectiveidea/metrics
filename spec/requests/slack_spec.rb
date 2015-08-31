describe "POST /slack" do
  let!(:user) { create(:user, slack_id: "123", slack_name: "steve") }

  around do |example|
    begin
      @original_slack_command = ENV["SLACK_COMMAND"]
      ENV["SLACK_COMMAND"] = "hello"
      example.run
    ensure
      ENV["SLACK_COMMAND"] = @original_slack_command
    end
  end

  context "data point creation" do
    let!(:metric) { create(:metric, pattern: '^((?<user>[^ ]+) )?swore( (?<howbad>badly))?( (?<number>\d+(\.\d+)?) times)?$') }

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
      other_user = create(:user, slack_id: "456", slack_name: "brian")

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
      expect(data_point.user).to eq(other_user)
      expect(data_point.number).to eq(1)
    end

    it "creates a data point with a different number and user" do
      other_user = create(:user, slack_id: "456", slack_name: "brian")

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
      expect(data_point.user).to eq(other_user)
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
      expect(data_point.metadata["howbad"]).to eq("badly")
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

    it "bombs if the referenced user is unknown" do
      expect {
        post "/slack",
          text: "brian swore",
          user_id: user.slack_id,
          user_name: user.slack_name
      }.not_to change {
        DataPoint.count
      }

      expect(response.status).to eq(422)
      expect(response.body).to be_present
    end

    it "creates a data point for a very simple metric pattern" do
      simple_metric = create(:metric, pattern: "foo")

      expect {
        post "/slack",
          text: "foo",
          user_id: user.slack_id,
          user_name: user.slack_name
      }.to change {
        DataPoint.count
      }.from(0).to(1)

      data_point = DataPoint.last
      expect(data_point.metric).to eq(simple_metric)
      expect(data_point.user).to eq(user)
      expect(data_point.number).to eq(1)
    end

    it "accepts first person pronouns as references to self" do
      expect {
        post "/slack",
          text: "i swore",
          user_id: user.slack_id,
          user_name: user.slack_name
      }.to change {
        DataPoint.count
      }.from(0).to(1)

      data_point = DataPoint.last
      expect(data_point.metric).to eq(metric)
      expect(data_point.user).to eq(user)
      expect(data_point.number).to eq(1)
    end

    it "works case-insensitively" do
      expect {
        post "/slack",
          text: "I SWORE",
          user_id: user.slack_id,
          user_name: user.slack_name
      }.to change {
        DataPoint.count
      }.from(0).to(1)

      data_point = DataPoint.last
      expect(data_point.metric).to eq(metric)
      expect(data_point.user).to eq(user)
      expect(data_point.number).to eq(1)
    end

    it "returns a custom message" do
      metric.update!(feedback: "profanity += %{number}")

      post "/slack",
        text: "swore 2 times",
        user_id: user.slack_id,
        user_name: user.slack_name

      expect(response.body).to eq("profanity += 2")
    end
  end

  it "provides a help message" do
    create(:metric, name: "Foo", help: "i have # foos")
    create(:metric, name: "Bar", help: "i bar # times")

    expect {
      post "/slack",
        text: "help",
        user_id: user.slack_id,
        user_name: user.slack_name
    }.not_to change {
      DataPoint.count
    }

    expect(response.status).to eq(200)
    expect(response.body).to eq(<<-BODY.strip_heredoc)
      Foo: /hello i have # foos
      Bar: /hello i bar # times
      BODY
  end

  it "orders the help message by most recent data point" do
    create(:metric, name: "Foo", help: "i have # foos")
    bar = create(:metric, name: "Bar", help: "i bar # times")
    create(:data_point, metric: bar)

    expect {
      post "/slack",
        text: "help",
        user_id: user.slack_id,
        user_name: user.slack_name
    }.not_to change {
      DataPoint.count
    }

    expect(response.status).to eq(200)
    expect(response.body).to eq(<<-BODY.strip_heredoc)
      Bar: /hello i bar # times
      Foo: /hello i have # foos
      BODY
  end
end
