require "google/api_client"

class GoogleCalendarAPI
  attr_reader :calendar_id

  def initialize(calendar_id)
    @calendar_id = calendar_id
  end

  def events
    results = fetch_events.map { |json| CalendarEvent.new(event_json_data_format(json)) }
    results.reject { |event| event.start_time.nil? || event.end_time.nil? }
  end

  def event_json
    fetch_events
  end

  protected

  def default_start_time
    DateTime.now.beginning_of_day
  end

  def default_end_time
    DateTime.now.end_of_day + 1.day
  end

  def fetch_events(start_time = default_start_time, end_time = default_end_time)
    request_params = { calendarId: calendar_id }
    request_params[:timeMin] = start_time if start_time
    request_params[:timeMax] = end_time if end_time

    client = google_api_client
    response = client.execute(
      api_method: client.discovered_api("calendar", "v3").events.list,
      parameters: request_params
    )

    json_data = JSON.parse(response.body)
    json_data["items"]
  end

  def event_json_data_format(json)
    {
      start_time: parse_date_string(json, "start"),
      end_time: parse_date_string(json, "end"),
      summary: json["summary"],
      url: json["htmlLink"]
    }
  end

  def parse_date_string(json, key)
    return nil unless json[key]

    if json[key]["date"]
      Date.parse(json[key]["date"])
    elsif json[key]["dateTime"]
      DateTime.parse(json[key]["dateTime"])
    end
  end

  def key
    if ENV["GOOGLE_P12_PEM"]
      Rails.logger.debug "#{self.class.name}: Using GOOGLE_P12_PEM PKCS12 " \
        "from the environment."
      return OpenSSL::PKey::RSA.new(ENV["GOOGLE_P12_PEM"], "notasecret")
    end

    keyfile = Dir["#{Rails.root}/*.p12"].first
    if keyfile
      Rails.logger.debug "#{self.class.name}: Using #{keyfile} PKCS12."
      return Google::APIClient::KeyUtils.load_from_pkcs12(keyfile, "notasecret")
    else
      Rails.logger.debug "#{self.class.name}: No PKCS12 found."
    end

    nil
  end

  def oauth2_client
    oauth2_client_params = {
      token_credential_uri: "https://accounts.google.com/o/oauth2/token",
      audience: "https://accounts.google.com/o/oauth2/token",
      scope: "https://www.googleapis.com/auth/calendar.readonly",
      issuer: ENV["GOOGLE_SERVICE_ACCOUNT_EMAIL"],
      signing_key: key
    }

    Signet::OAuth2::Client.new(oauth2_client_params)
  end

  def google_api_client
    api_client_params = {
      application_name: "HorizonDashboard",
      application_version: "0.0.1"
    }

    client = Google::APIClient.new(api_client_params)
    client.authorization = oauth2_client
    client.authorization.fetch_access_token!
    client
  end
end
