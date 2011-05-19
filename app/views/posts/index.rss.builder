xml.instruct!
 
xml.rss("version" => "2.0",
        "xmlns:dc"   => "http://purl.org/dc/elements/1.1/",
        "xmlns:atom" => "http://www.w3.org/2005/Atom") do
  xml.channel do
    xml.title       Changelog::Application.config.site_title
    xml.link        Changelog::Application.config.site_url
    xml.pubDate     Time.now.rfc822
    xml.description Changelog::Application.config.site_description
    xml.atom :link, "href" => "#{Changelog::Application.config.site_url}posts.rss", "rel" => "self", "type" => "application/rss+xml"

    @posts.each do |entry|
      xml.item do
        xml.title        entry.title
        xml.link         "#{Changelog::Application.config.site_url}log/#{entry.permalink}"
        xml.guid         "#{Changelog::Application.config.site_url}log/#{entry.permalink}"
        xml.description  entry.body
        xml.pubDate      entry.created_at.to_formatted_s(:rfc822)
        xml.dc :creator, Changelog::Application.config.author
      end
    end
  end
end
