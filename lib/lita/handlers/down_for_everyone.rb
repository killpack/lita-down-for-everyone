require "lita"

module Lita
  module Handlers
    class DownForEveryone < Handler
      route(/\bis (.+) down\b/i, :is_site_down, command: true, help: { "is SOME_URL down?" => "Tells you whether SOME_URL is working or not." })

      def is_site_down(response)
        site_url = response.matches[0][0]
        site_url = sanitize(site_url) if site_url_from_slack?(site_url)
        api_url  = api_url(site_url) 
        username = response.user.name

        response_html = http.get(api_url).body

        if response_html.include? "looks down from here."
          response.reply "#{username}: Looks like #{site_url} is down. #{api_url}"
        elsif response_html.include? "It's just you."
          response.reply "#{username}: It's just you: looks like #{site_url} is up. #{api_url}"
        end
      end

      private

      def api_url(site_url)
        "http://isup.me/#{site_url}"
      end

      def sanitize(site_url)
        URI.extract(site_url)[0].split("//")[1]
      end

      def site_url_from_slack?(site_url)
        true if site_url.match(/</)
      end
    end

    Lita.register_handler(DownForEveryone)
  end
end
