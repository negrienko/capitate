require 'active_support'
require 'highline'
require 'capistrano'

HighLine.track_eof = false

# Add this path to ruby load path
$:.unshift File.dirname(__FILE__)

module Capitate # :nodoc:
 module Plugins # :nodoc:
 end  
end

require 'capitate/plugins/base'
require 'capitate/plugins/gem'
require 'capitate/plugins/package'
require 'capitate/plugins/profiles'
require 'capitate/plugins/script'
require 'capitate/plugins/templates'
require 'capitate/plugins/wget'
require 'capitate/plugins/yum'

require "capitate/cap_ext/connections"
require "capitate/cap_ext/extension_proxy"
require "capitate/cap_ext/variables"
        
class Capistrano::Configuration   
  include Capitate::CapExt::Variables
end
