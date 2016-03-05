require 'ServiceNow/task'

module ServiceNow
  class Request < ServiceNow::Task
    attr_reader :connection, :target

    def initialize(connection)
      super(connection)
      @target = 'sc_request'
    end
  end
end
