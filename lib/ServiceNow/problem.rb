require 'ServiceNow/task'

module ServiceNow
  class Problem < ServiceNow::Task
    attr_reader :connection, :target

    def initialize(connection)
      super(connection)
      @target = 'problem'
    end
  end
end
