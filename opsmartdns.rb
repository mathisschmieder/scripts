#!/usr/bin/env ruby

name = "USERNAME"
password = "PASSWORD"

require 'mechanize'
agent = Mechanize.new

agent.user_agent_alias = 'Linux Mozilla'
agent.open_timeout = 3
agent.read_timeout = 4
agent.keep_alive = false

url = 'http://automation.whatismyip.com/n09230945.asp'
page = agent.get url
localip = page.body

url = 'https://www.overplay.net/login.php'
page = agent.get url
login_form = page.form_with(:action => 'https://www.overplay.net/login.php')
login_form['username'] = name
login_form['password'] = password
page = agent.submit login_form

url = 'https://www.overplay.net/ajax/smartDnsStatus.php'
page = agent.get(url, {"service" => "1"})
smartDnsStatus = page.body

if smartDnsStatus.match(localip) then
   puts "did not change ip address " + localip
else
   puts "updated ip address to " + localip
   url = 'https://www.overplay.net/ajax/smartDnsStatus.php'
   page = agent.post(url, {"service" => "1", "address" => localip})
end
