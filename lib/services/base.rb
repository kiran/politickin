module Services

  module Base
    require 'net/http'

    def get_xml(url)
      begin
        xml_data = Net::HTTP.get_response(URI.parse(url)).body
        xml_data
      rescue Exception => e # Faux-log any failed requests.
        Rails.logger.warn("Failed to get xml for: #{url}")
        Rails.logger.warn(e.message)
        {}
      end
    end

    # Use the JSON and RestClient gems to get json from a url
    def get_json(url)
      begin
        JSON.parse(RestClient.get(URI.encode(url)))
      rescue JSON::ParserError => e # Faux-log any failed requests.
        Rails.logger.warn("Failed to parse json for: #{url}")
        Rails.logger.warn(e.message)
        {}
      end
    end

    # Ensure that a failed api call doesn't screw up the remainder of our data.
    def safe_request(title, opts={})
      # Rails.logger.info "starting: #{title}"
      result = {}
      return result if opts.has_key?(:ensure) && !opts[:ensure]
      begin
        result = yield
        # Rails.logger.info "done with: #{title}"
      rescue Exception => e
        Rails.logger.info "error for: #{title} ... #{e}"
        result = {}
      end
      result
    end

  end

end