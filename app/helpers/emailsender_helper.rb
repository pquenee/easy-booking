module EmailsenderHelper

 def email_all_booking_message(booking)
  emails = contacts_email
  contact = Contact.find(booking.contact_id)
  message = "From: WebCalendar <noreply@" << Rails.configuration.x.email_smtp_domain << ">\n"
  message << "To: " << emails.to_s << "\n"
  message << "Content-Type: text/plain; charset=\"utf-8\"\n"
  message << "Content-Transfer-Encoding: 8bit\n"
  message << "Subject: [" << Rails.configuration.x.name << "] Nouvelle réservation\n\n"
  message << "Ceci est un email automatique.\n"
  message << "Une nouvelle réservation a été effectuée du " << booking.start.to_s << " au " << booking.end.to_s << " pour " << booking.name << ".\n"
  message << "Cette réservation a été effectuée par " << contact.name << " joignable au " << contact.phone << ".\n"
  message << (booking.full_price + booking.reduced_price).to_s << " personne(s) prévue(s) en plus.\n\n"
  message << "Pour visualiser le calendrier merci de vous connecter à http://" << Rails.configuration.x.website_url << "\n"
  message << "Mot de passe: " << Rails.configuration.x.password 

  smtp = Net::SMTP.new(Rails.configuration.x.email_smtp_ip, Rails.configuration.x.email_smtp_port)
  # debug option
  if Rails.configuration.x.email_debug
    smtp.set_debug_output $stderr
    puts "emails to:"
    puts emails.to_s
    puts "message to send:"
    puts message
  end
  if Rails.configuration.x.email_smtp_ttls
  	smtp.enable_starttls
  else
	smtp.disable_starttls
  end
  smtp.start(Rails.configuration.x.email_smtp_domain, Rails.configuration.x.email_smtp_login, Rails.configuration.x.email_smtp_password, Rails.configuration.x.email_authtype) do
  	smtp.send_message(message, "noreply@" << Rails.configuration.x.email_smtp_domain, emails)
  end
 end

 private

 def contacts_email
  emails = []
  contacts = Contact.all
  contacts.each do |contact|
    emails.push(contact.email)
  end
  return emails
 end

end
