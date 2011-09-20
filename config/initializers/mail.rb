data = YAML.load_file("#{Rails.root}/config/email.yml")
s = data["settings"]

ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.smtp_settings = {
  :address              => s["address"],
  :port                 => s["port"],
  :domain               => s["domain"],
  :user_name            => s["user_name"],
  :password             => s["password"],
  :authentication       => s["authentication"],
  :enable_starttls_auto => s["enable_starttls_auto"]
}
