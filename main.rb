# frozen_string_literal: true

require 'ostruct'
require 'byebug'

require_relative 'vector'
require_relative 'printer'
require_relative 'entity'
require_relative 'display'
require_relative 'gamer'

# TracePoint.trace(:call, :line, :return) do |tp|
#   p [tp.lineno, tp.defined_class, tp.method_id, tp.event]
# end

BOARD_SIZE = VECTOR.new(x: 30, y: 30).freeze

DISPLAY = Ractor.new { Display.draw }

class Life
  def self.run

    20.times.each_with_index do |id|
      Ractor.new(id) do |id|
        Entity.new(id).movement
      end
    end

    # Ractor.new { Gamer.spawn }

    loop { }
  end
end

Life.run

