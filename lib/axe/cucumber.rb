require 'axe/rspec/matchers'
require 'axe/cucumber/configuration'
require 'axe/cucumber/steps'

# expose rspec matchers to cucumber steps
World(Axe::RSpec::Matchers)
