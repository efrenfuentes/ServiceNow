require 'ServiceNow'
require 'sinatra/base'
require 'sinatra/contrib/all'
require 'icalendar'

class ServiceNow_Query < Sinatra::Base

  register Sinatra::Contrib

  configure do
    set :wsdl_url, 'https://demo000.service-now.com/'
    set :user, 'admin'
    set :password, 'admin'

    set :valid_tables, %w(approval change incident problem request requested_item sc_task task ticket)
  end

  helpers do

    def valid_table?(table)
      settings.valid_tables.include? table
    end

    def get_object_to_query(table)
      connection = ServiceNow::Connection.new(settings.wsdl_url, settings.user, settings.password)

      if valid_table? table
        if table == 'approval'
          ServiceNow::Approval.new connection
        elsif table == 'change'
          ServiceNow::Change.new connection
        elsif table == 'incident'
          ServiceNow::Incident.new connection
        elsif table == 'problem'
          ServiceNow::Problem.new connection
        elsif table == 'request'
          ServiceNow::Request.new connection
        elsif table == 'requested_item'
          ServiceNow::RequestedItem.new connection
        elsif table == 'sc_task'
          ServiceNow::SC_Task.new connection
        elsif table == 'task'
          ServiceNow::Task.new connection
        elsif table == 'ticket'
          ServiceNow::Ticket.new connection
        end
      else
        nil
      end
    end

    def query(table, field, value)
      condition = { field => value }
      item = get_object_to_query(table)

      item.query(condition)
    end

    def to_icalendar(result)
      calendar = Icalendar::Calendar.new

      result.each do |item|
          start_data = /^(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})/.match(item[:start_date])
          start_date = "#{start_data[:year]}#{start_data[:month]}#{start_data[:day]}"
          end_data = /^(?<year>\d{4})-(?<month>\d{2})-(?<day>\d{2})/.match(item[:end_date])
          end_date = "#{end_data[:year]}#{end_data[:month]}#{end_data[:day]}"
          calendar.event do |e|
            e.dtstart = Icalendar::Values::Date.new(start_date)
            e.dtend = Icalendar::Values::Date.new(end_date)
            e.summary = item[:number]
            e.description = item[:short_description]
          end
      end

      calendar.to_ical
    end

  end

  before /.*/ do
    if request.url.match(/.ics$/)
      request.accept.unshift('text/calendar')
      request.path_info = request.path_info.gsub(/.ics$/,'')
    end
  end

  get '/:table/:field/:value', :provides => [:ics]  do
    table = @params[:table]
    field = @params[:field]
    value = @params[:value]

    result = query(table, field, value)

    respond_to do |format|
      format.ics { to_icalendar(result) }
    end
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end