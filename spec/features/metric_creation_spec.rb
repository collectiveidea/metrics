feature "Metric Creation" do
  scenario "A visitor can create a metric" do
    name = "Swear Jar"
    pattern = "(?<user>[^ ]+) swore( (?<number>\d+) times)?"
    example = "i swore"

    visit new_metric_path

    expect {
      form = DOM::Metric::Form.find!
      form.name = name
      form.pattern = pattern
      form.example = example
      form.submit
    }.to change {
      Metric.count
    }.by(1)

    metric = Metric.last

    expect(current_path).to eq(metrics_path)

    row = DOM::Metric::Row.first
    expect(row.name).to eq(name)
    expect(row.example).to eq(example)

    row.view

    expect(current_path).to eq(metric_path(metric))

    detail = DOM::Metric::Detail.find!
    expect(detail.name).to eq(name)
    expect(detail.pattern).to eq(pattern)
    expect(detail.example).to eq(example)
  end
end
