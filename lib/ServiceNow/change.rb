require 'ServiceNow/task'

module ServiceNow
  class Change < ServiceNow::Task
    attr_reader :connection, :target

    def initialize(connection)
      super(connection)
      @target = 'change_request'
    end
  end
end