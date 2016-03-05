require 'savon'

module ServiceNow
  class Connection
    attr_reader :wsdl_end_point, :user, :password

    def initialize(wsdl_end_point, user=nil, password=nil)
      @wsdl_end_point = wsdl_end_point
      @user = user
      @password = password
    end

    def call(target, operation, message={})
      url = @wsdl_end_point + target + '.do?WSDL'
      user = @user
      password = @password
      client = Savon.client do
        convert_request_keys_to :none
        wsdl url
        basic_auth user, password
      end
      client.call(operation, message: message)
    end
  end
end
