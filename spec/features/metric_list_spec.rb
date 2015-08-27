feature "Metric List" do
  it "lists all metrics" do
    metrics = create_list(:metric, 10)

    visit metrics_path

    list = DOM::Metric::List.find!
    expect(list.names).to match_array(metrics.map(&:name))
  end

  it "lists most recently used metrics first" do
    metric_1, metric_2, metric_3, metric_4 = create_list(:metric, 4)
    create(:data_point, metric: metric_1)
    create(:data_point, metric: metric_3)
    create(:data_point, metric: metric_2)

    visit metrics_path

    list = DOM::Metric::List.find!
    expect(list.names).to eq([
      metric_2.name,
      metric_3.name,
      metric_1.name,
      metric_4.name
    ])
  end
end
