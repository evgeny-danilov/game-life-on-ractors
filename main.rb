# frozen_string_literal: true

require 'ostruct'
require 'byebug'

require_relative 'lib/vector'
require_relative 'lib/printer'
require_relative 'lib/entity'
require_relative 'lib/display'
require_relative 'lib/gamer'

# TracePoint.trace(:call, :line, :return) do |tp|
#   p [tp.lineno, tp.defined_class, tp.method_id, tp.event]
# end

BOARD_SIZE = VECTOR.new(x: 500, y: 500).freeze

class Life
  def self.run
    entity_ractors = spawn_entities(count: 150)

    frame = 0
    entities = {}

    loop do
      entity_ractors.each { _1.send(entities.dup.freeze) }

      entities = entity_ractors.map(&:take).to_h
      area = Display.generate_area(entities)
      Printer.call(area, frame: frame)
      frame += 1

    end
  end

  def self.spawn_entities(count:)
    count.times.each_with_index.map do |id|
      Ractor.new(id) do |id|
        Entity.spawn(id)
      end
    end
  end
end

Life.run

