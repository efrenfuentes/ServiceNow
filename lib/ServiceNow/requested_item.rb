require 'ServiceNow/task'

module ServiceNow
  class RequestedItem < ServiceNow::Task
    attr_reader :connection, :target

    def initialize(connection)
      super(connection)
      @target = 'sc_req_item'
    end
  end
end
