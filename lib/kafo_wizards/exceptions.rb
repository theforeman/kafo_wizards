module KafoWizards

    class ValidationError < StandardError
      attr_reader :messages

      def initialize(msg=nil)
        messages = [msg].flatten(1)
        super(messages.join("; "))
        @messages = messages
      end
    end
end
