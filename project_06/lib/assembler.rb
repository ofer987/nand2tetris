# frozen_string_literal: true

require_relative 'assembler/version'
require_relative 'assembler/ram'
require_relative 'assembler/line'
require_relative 'assembler/nil_line'

require 'active_support'
require 'active_support/core_ext'

module Assembler
  class Error < StandardError; end
  # Your code goes here...
end
