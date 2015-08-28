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

      def help
        node.find_field("metric[help]").value
      end

      def help=(value)
        node.fill_in("metric[help]", with: value)
      end

      def feedback
        node.find_field("metric[feedback]").value
      end

      def feedback=(value)
        node.fill_in("metric[feedback]", with: value)
      end

      def submit
        node.find("[type=submit]").click
      end
    end

    class List < Domino
      include Enumerable

      selector ".metric-list"

      delegate :each, to: :rows

      def rows
        within(node) { Row.all }
      end

      def names
        map(&:name)
      end
    end

    class Row < Domino
      selector ".metric-row"

      attribute :name, ".metric-row-name"
      attribute :help, ".metric-row-help"

      def view
        node.click_link("Stats")
      end

      def edit
        node.click_link("Edit")
      end

      def remove
        node.click_link("Remove")
      end
    end

    class Detail < Domino
      selector ".metric-detail"

      attribute :name, ".metric-detail-name"
      attribute :pattern, ".metric-detail-pattern"
      attribute :help, ".metric-detail-help"
      attribute :feedback, ".metric-detail-feedback"
    end
  end
end
