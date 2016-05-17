Feature: Provision and Install

  Background:
    Given I have a running server
    And I provision it

  Scenario: Install elasticsearch
    When I install elasticsearch
    Then it should be successful
    And elasticsearch should be running
    And it should be accepting connections on port 9200

  Scenario: Install logstash
    When I install logstash
    Then it should be successful
    And logstash should be running

  Scenario: Install kibana
    When I install kibana
    Then it should be successful
    And kibana should be running

  Scenario: Install nginx
    When I install nginx
    Then it should be successful
    And nginx should be running

  Scenario: Install apache2utils
    When I install apache2utils
    Then it should be successful

  Scenario: Create ssl certificate and rsa keys
    When I create the ssl directory
    Then it should be successful
    Then the ssl directory should contain the certificate and key

  Scenario: Install python_passlib
    When I install python_passlib
    Then it should be successful

  Scenario: Create kibana.htpasswd file with username and password
    When I create kibana.htpasswd file with username and password
    Then it should be successful
    Then the kibana.htpasswd file should exists

  Scenario: Copy the default file and paste as a kibana file
    When I copy the default file and paste as a kibana file
    Then it should be successful
    Then the kibana file should exists

