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

BOARD_SIZE = VECTOR.new(x: 10, y: 5).freeze

class Life
  def self.run
    entity_ractors = spawn_entities(count: 5)

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

