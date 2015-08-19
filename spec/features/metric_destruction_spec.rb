feature "Metric Destruction" do
  scenario "A visitor can destroy an existing metric" do
    create(:metric, name: "Swear Jar")
    create(:metric, name: "Hot Dogs")

    visit metrics_path
    row = DOM::Metric::Row.find_by!(name: "Swear Jar")
    row.remove

    expect(current_path).to eq(metrics_path)
    expect(DOM::Metric::Row.count).to eq(1)
  end
end
