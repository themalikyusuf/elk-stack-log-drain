require 'open3'

Given(/^I have a running server$/) do
  output, error, status = Open3.capture3 "vagrant reload"
  expect(status.success?).to eq(true)
end

And(/^I provision it$/) do
  output, error, status = Open3.capture3 "vagrant provision"
  expect(status.success?).to eq(true)
end

When(/^I install elasticsearch$/) do
  cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.elasticsearch.yml"
  output, error, @status = Open3.capture3 "#{cmd}"
end

Then(/^it should be successful$/) do
  expect(@status.success?).to eq(true)
end

And(/^([^"]*) should be running$/) do |pkg|
  case pkg
  when 'elasticsearch', 'logstash', 'kibana', 'nginx'
    output, error, status = Open3.capture3 "vagrant ssh -c 'sudo service #{pkg} status'"
    expect(status.success?).to eq(true)
    expect(output).to match("#{pkg} is running")
  else
    raise 'Not Implemented'
  end
end

And(/^it should be accepting connections on port ([^"]*)$/) do |port|
  output, error, status = Open3.capture3 "vagrant ssh -c 'curl -f http://localhost:#{port}'"
  expect(status.success?).to eq(true)
end

When(/^I install logstash$/) do
  cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.logstash.yml"
  output, error, @status = Open3.capture3 "#{cmd}"
end

When(/^I install kibana$/) do
  cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.kibana.yml"
  output, error, @status = Open3.capture3 "#{cmd}"
end

When(/^I install nginx$/) do
  cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.nginx.yml"
  output, error, @status = Open3.capture3 "#{cmd}"
end

When(/^I install apache2utils$/) do
  cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.nginx.yml --tags 'apache2utils_setup'"
  output, error, @status = Open3.capture3 "#{cmd}"
end

When(/^I install python_passlib$/) do
  cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.nginx.yml --tags 'python_passlib_setup'"
  output, error, @status = Open3.capture3 "#{cmd}"
end

When(/^I create the ssl directory$/) do
  output, error, @status = Open3.capture3 "vagrant ssh -c 'ls /etc/nginx | grep ssl'"
  expect(output).to eq("ssl\n")
end

Then(/^the ssl directory should contain the certificate and key$/) do
  output, error, @status = Open3.capture3 "vagrant ssh -c 'ls /etc/nginx/sslz | grep server.*'"
  expect(output).to eq("server.crt\nserver.key\n")
end

When(/^I create kibana.htpasswd file with username and password$/) do
  cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.nginx.yml --tags 'kibana_htpasswd'"
  output, error, @status = Open3.capture3 "#{cmd}"
end

Then(/^the kibana.htpasswd file should exists$/) do
  output, error, @status = Open3.capture3 "vagrant ssh -c 'ls /etc/nginx/conf.d/ | grep kibana.htpasswd'"
  expect(output).to eq("kibana.htpasswd\n")
end

When(/^I copy the default file and paste as a kibana file$/) do
  cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.nginx.yml --tags 'default_kibana'"
  output, error, @status = Open3.capture3 "#{cmd}"
end

Then(/^the kibana file should exists$/) do
  output, error, @status = Open3.capture3 "vagrant ssh -c 'ls /etc/nginx/sites-available/ | grep kibana'"
  expect(output).to match("kibana")
end

