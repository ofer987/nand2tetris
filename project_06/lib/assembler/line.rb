# frozen_string_literal: true

class Line
  attr_reader :assembly, :binary

  def initialize(assembly, binary)
    @assembly = assembly.to_s
    @binary = binary.to_s
  end

  def to_s
    "#{assembly},#{binary}"
  end

  def nil?
    false
  end

  def blank?
    false
  end
end
