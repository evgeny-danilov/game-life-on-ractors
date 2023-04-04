require 'byebug'

class Cell
  attr_reader :x, :y, :state

  def initialize(x, y, state)
    @x = x
    @y = y
    @state = state
    @neighbor_refs = []
  end

  def update_state(live_neighbor_count)
    if @state == :dead && live_neighbor_count == 3
      send_all(:live)
      @state = :live
    elsif @state == :live && (live_neighbor_count < 2 || live_neighbor_count > 3)
      send_all(:dead)
      @state = :dead
    end
  end

  def add_neighbor_ref(ref)
    @neighbor_refs << ref
  end

  private

  def send_all(state)
    @neighbor_refs.each { |ref| ref.send(:update_state, @x, @y, state) }
  end
end

class Grid
  def self.start(size)
    neighbors = generate_neighbors(size)
    grid = generate_grid(size, neighbors)

    ractors = spawn_cells(grid)

    [grid, ractors]
  end

  def self.spawn_cells(grid)
    grid.map do |row|
      row.map do |cell|
        Ractor.new(cell, move: true) do |cell|
          loop do
            message, x, y, state = Ractor.receive

            case message
            when :get_state
              Ractor.yield(cell.state)
            when :update_state
              cell.update_state(count_live_neighbors(grid, cell.x, cell.y))
              broadcast_state(ractor_refs(cell), x, y, state)
            end
          end
        end
      end
    end
  end

  def self.generate_neighbors(size)
    (0...size).map do |y|
      (0...size).map do |x|
        [
          [x-1, y-1], [x, y-1], [x+1, y-1],
          [x-1, y],             [x+1, y],
          [x-1, y+1], [x, y+1], [x+1, y+1]
        ].select do |nx, ny|
          nx >= 0 && nx < size && ny >= 0 && ny < size
        end
      end
    end
  end

  def self.generate_grid(size, neighbors)
    (0...size).map do |y|
      (0...size).map do |x|
        cell = Cell.new(x, y, :dead)
        update_neighbors(cell, size, neighbors)
        cell
      end
    end
  end

  def self.update_neighbors(cell, size, neighbors)
    neighbors[cell.y][cell.x].each do |nx, ny|
      neighbor_ref = get_ref(nx, ny)
      cell.add_neighbor_ref(neighbor_ref)
      neighbor_ref.send(:add_neighbor_ref, cell)
    end
  end

  def self.count_live_neighbors(grid, x, y)
    grid[y][x].neighbor_refs.count { |ref| ref.take == :live }
  end

  def self.ractor_refs(cell)
    cell.neighbor_refs.map { |ref| get_ref(ref.ractor) }
  end

  def self.broadcast_state(refs, x, y, state)
    refs.each { |ref| ref.send(:update_state, x, y, state) }
  end

  def self.get_ref(ractor)
    Ractor.new(ractor) { |r| r }
  end
end

class Life
  def initialize(size)
    @size = size
    @grid, @ractors = Grid.start(size)
  end

  def start
    print_grid

    loop do
      sleep(0.2)
      update_grid
      print_grid
    end
  end

  def update_grid
    @grid.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        state = @ractors[y][x].send(:get_state)
        cell.update_state(Grid.count_live_neighbors(@grid, x, y)) unless state == cell.state
      end
    end
  end

  def print_grid
    system('clear') || system('cls')

    @grid.each do |row|
      puts row.map { |cell| cell.state == :live ? '●' : '○' }.join(' ')
    end
  end
end

Life.new(20).start

