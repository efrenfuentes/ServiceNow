require 'ServiceNow/base'

module ServiceNow
  class Approval < ServiceNow::Base
    attr_reader :connection, :target

    def initialize(connection)
      super(connection)
      @target = 'sysapproval_approver'
    end
  end
end