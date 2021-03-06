get '/' do
  @page_name = 'Home'
  @page_desc = "Patricia Van Reenen is an individual, couple, and family counsellor based in London, Ontario."
  erb :index
end

get '/covid-19/?' do
  @page_name = 'Office Procedures During COVID-19'
  @page_desc = "During the COVID-19 pandemic, I am offering remote therapy sessions via Zoom or telephone."
  erb :"covid-19"
end

get '/about/?' do
  @page_name = 'About'
  @page_desc = "Educational qualifications, clinical counselling experience, and professional memberships."
  erb :about
end

get '/services/?' do
  @page_name = 'Services'
  @page_desc = "Confidential, professional counselling for individuals, couples and families encountering difficulties in many different areas."
  erb :services
end

get '/fees_hours/?' do
  @page_name = 'Fees and Hours'
  @page_desc = "Fees and hours of business."
  erb :fees_hours
end

get '/location/?' do
  @page_name = 'Location'
  @page_desc = "Map and directions to Patricia Van Reenen's private practice in London, Ontario."
  erb :location
end

get '/contact/?' do
  @page_name = 'Contact'
  @page_desc = "How to contact Patricia Van Reenen."
  erb :contact
end

get '/faq/?' do
  @page_name = 'FAQ'
  @page_desc = "Frequently Asked Questions regarding counselling and Patricia Van Reenen's private practice."
  erb :faq
end

get '/resources/?' do
  @page_name = 'Resources'
  @page_desc = "Therapy, counselling, and mental health care resources in London, Ontario and the surrounding area."
  erb :resources
end

get '/about_site/?' do
  @page_name = 'About this Site'
  @page_desc = "Technical details regarding Patricia Van Reenen's website."
  erb :about_site
end

get '/privacy/?' do
  @page_name = 'Privacy'
  @page_desc = "Site Privacy Policy.  Gives information regarding cookies and the collection of personal and non-personal information."
  erb :privacy
end

get '/contact_web/?' do
  @page_name = 'Contact the Webmaster'
  @page_desc = "Contact the webmaster regarding bugs or questions related to the site."
  erb :contact_web
end

get '/thank_you/?' do
  @page_name = 'Thank You'
  @page_desc = "Your email has been sent."
  erb :thank_you
end

get '/contact_failure/?' do
  @page_name = 'Contact Failure'
  @page_desc = "Your email has not been sent."
  erb :contact_failure
end

post '/contact' do
  if ENV['RACK_ENV'] == 'test' || recaptcha_ok
    Pony.mail   :to => 'patricia@pvanreenen.com',
                :from => "pvanreenen.com <sinatra@pvanreenen.com>",
                :reply_to => params[:email],
                :subject => params[:subject],
                :body => erb(:email, :layout => false)
    redirect 'thank_you'
  else
    redirect 'contact_failure'
  end
end

post '/contact_web' do
  if ENV['RACK_ENV'] == 'test' || recaptcha_ok
    Pony.mail   :to => 'webmaster@pvanreenen.com',
                :from => "pvanreenen.com <sinatra@pvanreenen.com>",
                :reply_to => params[:email],
                :subject => params[:subject],
                :body => erb(:email, :layout => false)
    redirect 'thank_you'
  else
    redirect 'contact_failure'
  end
end

def recaptcha_ok
  recaptcha_response = params[:"g-recaptcha-response"]

  options = {
    body: {
      secret: ENV['RECAPTCHA_SECRET_KEY'],
      response: recaptcha_response
    }
  }

  verification = HTTParty.post('https://www.google.com/recaptcha/api/siteverify', options)
  !!verification["success"]
end

