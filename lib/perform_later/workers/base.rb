module PerformLater
  module Workers
    class Base

      protected
      def self.perform_job(object, method, arguments)
        object.send(method, *arguments)
      end
    end
  end
end
