$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'pry'
require 'json'
require 'minitest/autorun'
require 'mocha/mini_test'
require 'sevak'

SEVAK_ENV = 'test'