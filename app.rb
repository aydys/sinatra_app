#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def is_barber_exists? db, name
	db.execute('select * from Barbers where name=?', [name]).length > 0		
end

def seed_db db, barbers
	barbers.each do |barber|
		if !is_barber_exists? db, barber
			db.execute 'insert into Barbers (name) values (?)', [barber]
		end
	end
end

before do
	db = get_db
	@results_barber = db.execute 'select * from Barbers'
end

def get_db
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	return db
end

configure do
	db = get_db
	db.execute 'create table if not exists
		"Users"
		(
			"id" integer primary key autoincrement,
			"username" text,
			"phone" text,
			"datestamp" text,
			"barber" text,
			"color" text
		)'

	db.execute 'create table if not exists
	"Barbers"
	(
		"id" integer primary key autoincrement,
		"name" text
	)'

	seed_db db, ['Jessie Pinkman', 'Walter White', 'Gus Fring', 'Mike Ehrmantraut']
end

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
	
	hh = { 
		:username => 'Enter your name',
		:phone => 'Enter your phone',
		:datetime => 'No correct datetime'
	}

	@error = hh.select {|key, _| params[key] == ''}.values.join(', ')
	
	if @error != ''
		return erb :visit
	end

	db = get_db
	db.execute 'insert into Users 
		(
			username, 
			phone, 
			datestamp, 
			barber
		)
		values 
		( ?, ?, ?, ?)', [@username, @phone, @date_time,  @master]

	erb "Thanks, you maked an appointment"
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

get '/showusers' do
	db = get_db

	@results = db.execute 'select * from Users order by id desc'

	erb :showusers
end