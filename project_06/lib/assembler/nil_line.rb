# frozen_string_literal: true

class NilLine
  def initialize; end

  def to_s
    ''
  end

  def nil?
    true
  end

  def blank?
    true
  end
end
