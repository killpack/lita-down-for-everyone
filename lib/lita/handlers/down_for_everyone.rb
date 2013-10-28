require "lita"

module Lita
  module Handlers
    class DownForEveryone < Handler
      route(/\bis (.+) down\b/i, :is_site_down, command: true, help: { "is SOME_URL down?" => "Tells you whether SOME_URL is working or not." })

      def is_site_down(response)
        site_url = response.matches[0][0]
        api_url = api_url(response.matches[0][0]) 
        response_html = http.get(api_url).body

        if response_html.include? "looks down from here."
          response.reply "Looks like #{site_url} is down. #{api_url}"
        elsif response_html.include? "It's just you."
          response.reply "It's just you: looks like #{site_url} is up. #{api_url}"
        end
      end

      private

      def api_url(site_url)
        "http://isup.me/#{site_url}"
      end
    end

    Lita.register_handler(DownForEveryone)
  end
end
