require 'ServiceNow/task'

module ServiceNow
  class Ticket < ServiceNow::Task
    attr_reader :connection, :target

    def initialize(connection)
      super(connection)
      @target = 'ticket'
    end
  end
end