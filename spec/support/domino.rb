module DOM
  module Metric
    class Form < Domino
      selector ".metric-form"

      def name
        node.find_field("metric[name]").value
      end

      def name=(value)
        node.fill_in("metric[name]", with: value)
      end

      def pattern
        node.find_field("metric[pattern]").value
      end

      def pattern=(value)
        node.fill_in("metric[pattern]", with: value)
      end

      def submit
        node.find("[type=submit]").click
      end
    end

    class List < Domino
      selector ".metric-list"

      def rows
        within(node) { Row.all }
      end
    end

    class Row < Domino
      selector ".metric-row"

      attribute :name, ".metric-row-name"

      def view
        node.click_link("View")
      end

      def edit
        node.click_link("Edit")
      end
    end

    class Detail < Domino
      selector ".metric-detail"

      attribute :name, ".metric-detail-name"
      attribute :pattern, ".metric-detail-pattern"
    end
  end
end
