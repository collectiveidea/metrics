class Tally < Metric
  def ping(text:, user:)
    match = regexp.match(text)
    number = match[:number] || 1
    user = match[:user] || user

    data_points.create!(number: number, user: user)
  end
end
