require 'rubygems'
require 'mechanize'

agent = Mechanize.new
page = agent.get('http://linkedin.com/')
login_form = page.forms.first

username_field = login_form.field_with(:name => "session_key")
username_field.value = "EMAIL ADDRESS"
password_field = login_form.field_with(:name => "session_password")
password_field.value = "PASSWORD"
login_form.submit

# Change URL to the URL of the Manage Group page
new_page = agent.get('URL')
member_page = new_page.link_with(:text => " Members ").click

stop = false
counter = 0

until stop == true
  # checks all boxes on page
  form = member_page.form_with(:name => 'participantListForm')
  allcheckboxes = form.checkboxes
  allcheckboxes.each do |checkbox|
    checkbox.check
  end

  # submits form
  button = form.button_with(:name => 'subMbrsActn-ma-swal2p', :class => 'bulkRequest')
  next_page = form.submit(button)

  # Moves on to next page if there is one
  if link = member_page.link_with(:text => "Next")
    member_page = link.click
    counter = counter + 1
    members = counter * 50
    puts "First #{members} members are now moderated."
  else
    stop = true
  end
end