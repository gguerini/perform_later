module Resque
  module Mailer
    module ClassMethods
      def perform(action, *args)
        return if environment_excluded?

        args = PerformLater::ArgsParser.args_from_resque(args)
        self.send(:new, action, *args).message.deliver
      end

      def environment_excluded?
        !ActionMailer::Base.perform_deliveries || excluded_environment?(current_env)
      end
    end

    class MessageDecoy
      def deliver
        return deliver! if environment_excluded?

        args = PerformLater::ArgsParser.args_to_resque(@args)
        resque.enqueue(@mailer_class, @method_name, *args)
      end
    end
  end
end
