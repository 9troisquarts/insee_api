require 'rest-client'
require 'json'
require "base64"

module InseeApi
  class Client
    attr_reader :access_id, :secret_access_key

    INSEE_ROOT_URL = "https://api.insee.fr"
    USERNAME = ENV['INSEE_ACCESS_ID']
    PASSWORD = ENV['INSEE_ACCESS_SECRET_KEY']

    def initialize(access_key_id = nil, secret = nil)
      @access_id = access_key_id || ENV['INSEE_ACCESS_ID']
      @secret_access_key = secret || ENV['INSEE_ACCESS_SECRET_KEY']

      raise "Bad credentials" unless @access_id.is_a?(String) && @secret_access_key.is_a?(String)
      raise "Credentils is required" unless @access_id.size > 0 && @secret_access_key.size > 0
    end

    def send_request(url, data: nil, headers: nil, attempt: 0)
      unless headers
        @@access_token ||= nil
        @@token_expire_at ||= nil
        # Refresh token is nil or if expires in less than 10 min
        get_token if @@access_token.nil? || @@access_token.size === 0 || @@token_expire_at.nil? || @@token_expire_at < (Time.now + 600)
        headers = {
          Authorization: "Bearer #{@@access_token }",
          Accept: 'application/json'
        }
      end
      begin
        response = RestClient.post(INSEE_ROOT_URL + url, data, headers)
        return JSON.parse(response)
      rescue => e
        if attempt <= 3 && e.response && e.response.code.to_i == 401
          @@access_token = nil
          @@token_expire_at = nil
          send_request(url, data: data, headers: headers, attempt: attempt+1)
        else
          raise e
        end
      end
    end

    def get_token
      data = {
        grant_type: "client_credentials"
      }
      response_json = send_request('/token', data: data, headers: {
         Authorization: "Basic #{Base64.strict_encode64("#{@access_id}:#{@secret_access_key}")}"
      });
      access_token = response_json['access_token']
      expires_in = response_json['expires_in']
      @@access_token = access_token
      @@token_expire_at = Time.now + expires_in
    end
  end
end