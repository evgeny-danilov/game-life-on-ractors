# frozen_string_literal: true

VECTOR = Struct.new(:x, :y, keyword_init: true) do
  def +(vector)
    VECTOR.new(
      x: self.x + vector.x,
      y: self.y + vector.y
    )
  end

  def to_a
    [x, y]
  end
end
