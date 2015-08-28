feature "Metric Creation" do
  scenario "A visitor can create a metric" do
    name = "Swear Jar"
    pattern = "(?<user>[^ ]+) swore( (?<number>\d+) times)?"
    help = "i swore"
    feedback = "Whoops!"

    visit new_metric_path

    expect {
      form = DOM::Metric::Form.find!
      form.name = name
      form.pattern = pattern
      form.help = help
      form.feedback = feedback
      form.submit
    }.to change {
      Metric.count
    }.by(1)

    metric = Metric.last

    expect(current_path).to eq(metrics_path)

    row = DOM::Metric::Row.first
    expect(row.name).to eq(name)
    expect(row.help).to eq(help)

    row.edit

    expect(current_path).to eq(edit_metric_path(metric))

    form = DOM::Metric::Form.find!
    expect(form.name).to eq(name)
    expect(form.pattern).to eq(pattern)
    expect(form.help).to eq(help)
    expect(form.feedback).to eq(feedback)
  end
end
