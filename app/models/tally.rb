class Tally < Metric
  def ping(text:, user:)
    match = regexp.match(text)
    number = match[:number] || 1
    data = Hash[match.names.zip(match.captures)]
    data["user"] = match[:user] || user

    data_points.create!(number: number, data: data)
  end
end
