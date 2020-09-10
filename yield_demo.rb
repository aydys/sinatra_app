def get_website_contents
  puts "<body>"
  5.times do
    yield    
  end
  puts "</body>"
end

get_website_contents { puts "something" }