describe Metric do
  context "validations" do
    describe "#example" do
      it "must match the pattern" do
        metric = build(:metric, pattern: "(foo|bar)")

        expect(metric).to accept_values_for(:example, "foo", "bar")
        expect(metric).not_to accept_values_for(:example, "baz", "qux")
      end

      it "is required" do
        metric = build(:metric, pattern: "(foo|bar)?")

        expect(metric).not_to accept_values_for(:example, "", nil)
      end
    end
  end
end
