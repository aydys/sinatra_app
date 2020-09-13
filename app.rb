#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	@error = 'something error!!!'
	erb :about
end

get '/visit' do
	erb :visit
end

get '/contacts' do
	erb :contacts
end

post '/visit' do
	@username = params[:username]
	@phone = params[:phone]
	@date_time = params[:datetime]
	@master = params[:master]

	@title = 'Thank you'
	@message = "Dear #{@username}, we'll waiting for you at #{@date_time}. Your master: #{@master}"

	f = File.open './public/users.txt', 'a'
	f.write "User: #{@username}, Phone: #{@phone}, Date and time: #{@date_time}, master: #{@master} \n"

	f.close

	erb :message
end

post '/contacts' do
	@username = params[:username]
	@email = params[:email]
	@contact_message = params[:contact_message]
	@title = 'Thank you'
	@message = "Dear #{@username}, we'll answer you soon"

	f = File.open './public/contacts.txt', 'a'
	f.write "User: #{@username}, message: #{@contact_message}\n"

	f.close

	erb :message
end
