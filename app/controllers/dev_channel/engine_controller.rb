require "dev_channel/asset_change_server"
module DevChannel
  class EngineController < ActionController::Base
    before_filter :require_websocket
    def connection
      if websocket
        DevChannel::Connection.new(websocket)
        websocket << ["HELLO FROM RAILS!"].to_json
        self.status, self.headers, self.response_body = 200, {}, []
      else
        render text: "???", layout: nil
      end
    rescue
      Rails.logger.warn "OH FUCK CONNECTION BROKE!"
    end

    def require_websocket
      websocket or false
    end

    def websocket
      @websocket ||= env["rack.websocket"]
    end
  end
end
