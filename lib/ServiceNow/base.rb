require 'ServiceNow/logging'

module ServiceNow
  class Base
    include Logging

    attr_reader :connection, :target

    def initialize(connection)
      @connection = connection
      @target = nil
    end

    def query(conditions={})
      logger.info "Query #{conditions} in #{@target}"
      response = @connection.call(@target, :get_records, conditions)
      result = (response.body[:get_records_response].nil?) ? [] : response.body[:get_records_response][:get_records_result]
      result = [result] if result.is_a? Hash

      result
    end
    
    def insert(item={})
      logger.info "Insert #{item} in #{@target}"
      response = @connection.call(@target, :insert, item)
      logger.debug "Response: #{response.body[:insert_response]}"

      result = query(response.body[:insert_response])
      result.first
    end

    def update(item={})
      logger.info "Update #{item} in #{@target}"
      if item.has_key?(:sys_id)
        response = @connection.call(@target, :update, item)
      else
        logger.info 'Web service update called without a sys_id'
        raise 'Web service update called without a sys_id'
      end
      logger.debug "Response: #{response.body[:update_response]}"
      response.body[:update_response][:sys_id]
    end
  end
end