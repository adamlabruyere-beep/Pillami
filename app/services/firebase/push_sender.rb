# app/services/firebase/push_sender.rb
require "googleauth"
require "net/http"
require "uri"
require "json"

module Firebase
  class PushSender
    SCOPE = "https://www.googleapis.com/auth/firebase.messaging".freeze

    def initialize
      @project_id = ENV.fetch("FIREBASE_PROJECT_ID")

      @authorizer =
        if ENV["FIREBASE_SERVICE_ACCOUNT_JSON"].present?
          Google::Auth::ServiceAccountCredentials.make_creds(
            json_key_io: StringIO.new(ENV["FIREBASE_SERVICE_ACCOUNT_JSON"]),
            scope: SCOPE
          )
        else
          Google::Auth.get_application_default(SCOPE)
        end
    end

    # Envoie une notification push
    # Retourne :success, :unregistered, ou :error
    def send_to_token(token:, title:, body:)
      return :error if token.blank?

      @authorizer.fetch_access_token!
      access_token = @authorizer.access_token

      uri = URI("https://fcm.googleapis.com/v1/projects/#{@project_id}/messages:send")

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(uri.path, {
        "Content-Type"  => "application/json; charset=utf-8",
        "Authorization" => "Bearer #{access_token}"
      })

      request.body = {
        message: {
          token: token,
          notification: { title: title, body: body }
        }
      }.to_json

      response = http.request(request)

      if response.is_a?(Net::HTTPSuccess)
        :success
      elsif response.body.include?("UNREGISTERED")
        Rails.logger.warn("FCM: Token unregistered, should be deleted")
        :unregistered
      else
        Rails.logger.error("FCM error: #{response.code} #{response.body}")
        :error
      end
    end
  end
end
