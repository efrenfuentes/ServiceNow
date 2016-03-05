require 'ServiceNow/base'
require 'ServiceNow/logging'

module ServiceNow
  class Task < ServiceNow::Base
    include Logging

    attr_reader :connection, :target

    def initialize(connection)
      super(connection)
      @target = 'task'
    end

    def close(number)
      conditions = { number: number }
      item = query(conditions).first
      logger.info "Close #{item} in #{@target}"
      update_state(item[:sys_id], 3) # close
    end

    def reopen(number)
      conditions = { number: number }
      item = query(conditions).first
      logger.info "Close #{item} in #{@target}"
      update_state(item[:sys_id], 1) # open
    end

    def reassign(number, group=nil, user=nil)
      conditions = { number: number }
      item = query(conditions).first
      logger.info "Reassing #{item} in #{@target} to group #{group} user #{user}"
      item[:assignment_group] = group
      item[:assigned_to] = user
      update(item)
    end

    protected

    def update_state(sys_id, state)
      item = {sys_id: sys_id, state: state}
      logger.info "Update state #{item} in #{@target}"
      update(item)
    end
  end
end