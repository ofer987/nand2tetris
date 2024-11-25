# frozen_string_literal: true

class RAM
  FIRST_STATIC_RAM_ADDRESS = 16
  LAST_STATIC_RAM_ADDRESS = 255

  FIRST_RAM_ADDRESS = 256
  LAST_RAM_ADDRESS = 16_383
  STATIC_ADDRESS_REGEX = /^@(Foo\..+)$/
  VARIABLE_ADDRESS_REGEX = /^@([^\d].+)$/

  def [](label)
    address_map[label]
  end

  def include?(label)
    address_map.include? label
  end

  def next_available_address
    result = increment_address(@current_available_address)
    return result if @current_available_address == LAST_RAM_ADDRESS

    Array(result..LAST_RAM_ADDRESS).each do |address|
      break if address == LAST_RAM_ADDRESS

      if allocated? address
        result = increment_address(result)

        reserved_address = allocated_memory[allocated_memory_index]
        @allocated_memory_index += 1 unless reserved_address == LAST_RAM_ADDRESS

        next
      end

      break
    end

    @current_available_address = result
  end

  def add_label(label, address)
    return if address_map.include? label

    address_map[label] = address
  end

  def initialize(allocated_memory_map)
    @current_available_address = nil
    @available_static_address = nil
    @address_map = allocated_memory_map

    allocate_memory(allocated_memory_map)
  end

  def add_labels(source_code)
    line_number = -1

    new_addresses = []
    source_code.each do |line|
      unless line.match? LABEL
        line_number += 1

        new_addresses.each do |new_address|
          address_map[new_address] = line_number unless address_map.include? new_address
        end

        new_addresses = []
        next
      end

      address = line.match(LABEL)[1].to_s
      new_addresses << address
    end

    address_map
  end

  def add_static_memory(source_code)
    source_code.each do |line|
      next unless line.match? STATIC_ADDRESS_REGEX

      static_name = line.match(STATIC_ADDRESS_REGEX)[1]

      increment_next_available_static_address
      address_map[static_name] = available_static_address
    end
  end

  def add_variables(source_code)
    source_code.each do |line|
      next if line.match? STATIC_ADDRESS_REGEX
      next unless line.match? VARIABLE_ADDRESS_REGEX

      variable_name = line.match(VARIABLE_ADDRESS_REGEX)[1]
      next if address_map.include? variable_name

      variable_address = next_available_address
      address_map[variable_name] = variable_address
    end
  end

  private

  def allocate_memory(memory_ramp)
    @allocated_memory = memory_ramp
      .map { |_key, value| value }
      .uniq
      .sort

    @allocated_memory_index = 0
  end

  def allocated?(address)
    reserved_address = allocated_memory[allocated_memory_index]
    return false if reserved_address.blank?

    # Has the address already been allocated?
    reserved_address == address
  end

  def increment_address(value)
    return FIRST_RAM_ADDRESS if value.nil?
    return FIRST_RAM_ADDRESS if value.negative?
    return LAST_RAM_ADDRESS if value >= LAST_RAM_ADDRESS

    value + 1
  end

  def increment_next_available_static_address
    if @available_static_address.nil?
      @available_static_address = FIRST_STATIC_RAM_ADDRESS

      return
    end

    if @available_static_address >= LAST_STATIC_RAM_ADDRESS
      raise "Cannot allocated more STATIC Memory beyond #{LAST_STATIC_RAM_ADDRESS}"
    end

    @available_static_address += 1
  end

  attr_reader :allocated_memory, :allocated_memory_index, :address_map, :available_static_address
end
