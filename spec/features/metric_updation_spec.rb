feature "Metric Updation" do
  scenario "A visitor can update an existing metric" do
    metric = create(:metric,
      name: "Swear Jar",
      pattern: "(?<user>[^ ]+) swore",
      example: "i swore"
    )

    name = "Donut Fund"
    pattern = "(?<user>[^ ]+) really wants? donuts"
    example = "i really want donuts"

    visit edit_metric_path(metric)

    form = DOM::Metric::Form.find!
    form.name = name
    form.pattern = pattern
    form.example = example
    form.submit

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
