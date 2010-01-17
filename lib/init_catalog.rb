require 'rubygems'
require 'require_all'

require_all File.dirname(__FILE__) + '/catalog/core/*.rb'
include Catalog::Core
