require 'ServiceNow'
require 'json'

connection = ServiceNow::Connection.new('https://demo000.service-now.com/',
                                        'admin',
                                        'admin')

# Incident
incident = ServiceNow::Incident.new connection

result = incident.query({number: 'INC0010094'}).first

puts result.inspect
