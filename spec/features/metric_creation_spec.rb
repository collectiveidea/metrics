feature "Metric Creation" do
  scenario "A visitor can create a metric" do
    name = "Swear Jar"
    pattern = "(?<name>[^ ]+) swore( (?<count>\d+) times)?"

    visit new_metric_path

    expect {
      form = DOM::Metric::Form.find!
      form.name = name
      form.pattern = pattern
      form.submit
    }.to change {
      Metric.count
    }.by(1)

    metric = Metric.last

    expect(current_path).to eq(metrics_path)

    row = DOM::Metric::Row.first
    expect(row.name).to eq(name)

    row.follow

    expect(current_path).to eq(metric_path(metric))

    detail = DOM::Metric::Detail.find!
    expect(detail.name).to eq(name)
    expect(detail.pattern).to eq(pattern)
  end
end
