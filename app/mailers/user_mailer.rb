class UserMailer < ActionMailer::Base
  @@data = YAML.load_file("#{Rails.root}/config/email.yml")
  default from: @@data["default"]["from"]

  def send_sqlite_data
    attachments["production.sqlite3"] = File.read("#{Rails.root}/db/production.sqlite3")
    mail(
      :to => @@data["default"]["to"],
      :subject => "[#{Changelog::Application.config.site_title}] DB Backup - #{Time.now.to_s(:db)}"
    )
  end
end
