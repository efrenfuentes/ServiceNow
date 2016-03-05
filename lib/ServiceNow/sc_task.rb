require 'ServiceNow/task'

module ServiceNow
  class SC_Task < ServiceNow::Task
    attr_reader :connection, :target

    def initialize(connection)
      super(connection)
      @target = 'sc_task'
    end
  end
end