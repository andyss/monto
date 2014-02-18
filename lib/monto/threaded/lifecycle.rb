# encoding: utf-8
module Monto
  module Threaded

    module Lifecycle

      private

      def _assigning
        Threaded.begin_execution("assign")
        yield
      ensure
        Threaded.exit_execution("assign")
      end

      def _assigning?
        Threaded.executing?("assign")
      end

      def _binding
        Threaded.begin_execution("bind")
        yield
      ensure
        Threaded.exit_execution("bind")
      end

      def _binding?
        Threaded.executing?("bind")
      end

      def _building
        Threaded.begin_execution("build")
        yield
      ensure
        Threaded.exit_execution("build")
      end

      def _building?
        Threaded.executing?("build")
      end

      def _creating?
        Threaded.executing?("create")
      end

      def _loading
        Threaded.begin_execution("load")
        yield
      ensure
        Threaded.exit_execution("load")
      end

      def _loading?
        Threaded.executing?("load")
      end

      module ClassMethods

        def _creating
          Threaded.begin_execution("create")
          yield
        ensure
          Threaded.exit_execution("create")
        end

      end
    end
  end
end
