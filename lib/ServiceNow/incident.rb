require 'ServiceNow/task'
require 'ServiceNow/logging'

module ServiceNow
  class Incident < ServiceNow::Task
    include Logging

    attr_reader :connection, :target

    def initialize(connection)
      super(connection)
      @target = 'incident'
    end

    def close(number)
      conditions = { number: number }
      item = query(conditions).first
      logger.info "Close #{item} in #{@target}"
      update_state(item[:sys_id], 7) # close
    end

    def reopen(number)
      conditions = { number: number }
      item = query(conditions).first
      logger.info "Close #{item} in #{@target}"
      update_state(item[:sys_id], 2) # open
    end

    def create_problem(number)
      conditions = { number: number }
      item = query(conditions).first
      logger.info "Create problem #{item} in #{@target}"

      result = nil
      unless item[:problem_id].nil?
        problem = ServiceNow::Problem.new @connection
        new_problem = {}
        new_problem[:short_description] = item[:short_description]
        new_problem[:cmdb_ci] = item[:cmdb_ci]
        new_problem = problem.insert(new_problem).first
        result = new_problem[:sys_id]
        item[:problem_id] = new_problem[:sys_id]
        update(item)
      end

      result
    end

    def create_change(number)
      conditions = { number: number }
      item = query(conditions).first
      logger.info "Create change #{item} in #{@target}"

      result = nil
      unless item[:problem_id].nil?
        change = ServiceNow::Change.new @connection
        new_change = {}
        new_change[:priority] = item[:priority]
        new_change[:impact] = item[:impact]
        new_change[:opened_by] = item[:opened_by]
        new_change[:cmdb_ci] = item[:cmdb_ci]
        new_change = change.insert(new_change).first
        result = new_change[:sys_id]
        item[:rfc] = new_change[:sys_id]
        update(item)
      end

      result
    end

    protected

    def update_state(sys_id, state)
      item = {sys_id: sys_id, incident_state: state}
      logger.info "Update state #{item} in #{@target}"
      update(item)
    end
  end
end
