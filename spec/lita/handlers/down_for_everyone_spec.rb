require "spec_helper"

describe Lita::Handlers::DownForEveryone, lita_handler: true do
  it { routes_command("is heroku.com down").to :is_site_down }
  it { routes_command("is github.com down again").to :is_site_down }

  describe "#is_site_down" do
    context "when the site is down" do
      let(:down_html) { 
<<HEREDOC
<html>
  <head>
    <title>Down For Everyone Or Just Me -> Check if your website is down or up?</title>
  </head>
  <body>
    <div id="container">
      It's not just you!  <a href="http:&#x2F;&#x2Fgoogle.com" class="domain">http:&#x2F;&#x2F;google.com</a> looks down from here.
      <p><a href="/">Check another site?</a></p>
      <br />
      <div class="ad-container">
        Is downtime destroying your website & business?
        <br>
        <a href="http://gk.site5.com/t/633">Time for a dependable web host - Special Offer!</a>
      </div>
    </div>
  </body>
</html>
HEREDOC
      }
      before do
        allow_any_instance_of(Faraday::Connection).to receive(:get).with("http://isup.me/google.com").and_return(double("Faraday::Response", status: 200, body: down_html)) 
      end

      it "replies that the site is down" do
        send_command("is google.com down?")
        expect(replies.last).to include("Looks like google.com is down. http://isup.me/google.com") 
      end
    end

    context "when the site is up" do
      let(:up_html) { 
<<HEREDOC
<html>
  <head>
    <title>Down For Everyone Or Just Me -> Check if your website is down or up?</title>
  </head>
  <body>
    <div id="container">
      It's just you.  <a href="http:&#x2F;&#x2F;github.com" class="domain">http:&#x2F;&#x2F;github.com</a></span> is up.
      <p><a href="/">Check another site?</a></p>
      <div class="ad-container">
      Web Hosting built for designers & developers -> <a href="http://gk.site5.com/t/634">Special Offer</a>
      </div>
    </div>
  </body>
</html>
HEREDOC
      }
      before do
        allow_any_instance_of(Faraday::Connection).to receive(:get).with("http://isup.me/github.com").and_return(double("Faraday::Response", status: 200, body: up_html)) 
      end

      it "replies that the site is up" do
        send_command("is github.com down?")
        expect(replies.last).to include("It's just you: looks like github.com is up. http://isup.me/github.com")
      end
    end

    context "when the given URL is invalid" do
      let(:invalid_html) {
<<HEREDOC
<html>
  <head>
    <title>Down For Everyone Or Just Me -> Check if your website is down or up?</title>
  </head>
  <body>
    <div id="container">
      Huh?  http:&#x2F;&#x2F;website doesn't look like a site on the interwho.
      <p><a href="/">Try again?</a></p>
    </div>
  </body>
</html>
HEREDOC
      }
      before do
        allow_any_instance_of(Faraday::Connection).to receive(:get).with("http://isup.me/website").and_return(double("Faraday::Response", status: 200, body: invalid_html)) 
      end
      it "doesn't reply at all" do
        expect {
          send_command("is website down?")
        }.to_not change{replies.count}
      end
    end
  end
end
