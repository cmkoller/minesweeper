class Minefield
  attr_reader :row_count, :column_count

  def initialize(row_count, column_count, mine_count)
    @column_count = column_count
    @row_count = row_count
    @mine_count = mine_count
    @minefield = create_minefield()
  end

  # IN MINEFIELD:
  # 0 = cleared and safe
  # 1 = uncleared and safe
  # 6 = uncleared, and it's a bomb!
  # 9 = cleard bomb tile - game over!

  def create_minefield()
    minefield = []
    @row_count.times do
      row = []
      # Add things to row
      @column_count.times do
        row << 1
      end
      minefield << row
    end
    fill_minefield(minefield)
  end

  def fill_minefield(minefield)
    placed_mines = 0
    while placed_mines < @mine_count
      x_coord = rand(@column_count)
      y_coord = rand(@row_count)
      unless minefield[y_coord][x_coord] == 6
        minefield[y_coord][x_coord] = 6
        placed_mines += 1
      end
    end
    minefield
  end

  # Return true if the cell been uncovered, false otherwise.
  def cell_cleared?(row, col)
    @minefield[row][col] == 0 || @minefield[row][col] == 9
  end

  # Uncover the given cell. If there are no adjacent mines to this cell
  # it should also clear any adjacent cells as well. This is the action
  # when the player clicks on the cell.
  def clear(row, col)
    cur = @minefield[row][col]
    # If the tile is bomb-free...
    if cur == 1
      @minefield[row][col] = 0
      adjacents = get_adjacents(row, col)

      # If there are no adjacent bombs, clear
      if adjacent_mines(row, col) == 0
        adjacents.each do |coord|
          clear(coord[0], coord[1])
        end
      end

    # If the tile has a bomb...
    elsif cur == 6
      @minefield[row][col] = 9
    end
  end

  # Helper function that returns array of tuples, representing coordinates
  # of adjacent squares to input square
  def get_adjacents(row, col)
    output = []
    # As long as we're not starting at the very first row...
    if row > 0
      if col > 0
        output << [row - 1, col - 1]
      end
      output << [row - 1, col]
      if col < @column_count
        output << [row - 1, col + 1]
      end
    end
    # No matter what row we're in...
    if col > 0
      output << [row, col - 1]
    end
    if col < @column_count - 1
      output << [row, col + 1]
    end
    # As long as we're not in the very last row...
    if row < @row_count - 1
      if col > 0
        output << [row + 1, col - 1]
      end
      output << [row + 1, col]
      if col < @column_count - 1
        output << [row + 1, col + 1]
      end
    end
    output
  end

  # Check if any cells have been uncovered that also contained a mine. This is
  # the condition used to see if the player has lost the game.
  def any_mines_detonated?
    detonated = false
    @minefield.each do |row|
      if row.include?(9)
        detonated = true
      end
    end
    detonated
  end

  # Check if all cells that don't have mines have been uncovered. This is the
  # condition used to see if the player has won the game.
  def all_cells_cleared?
    all_cleared = true
    @minefield.each do |row|
      if row.include?(1)
        all_cleared = false
      end
    end
    all_cleared
  end

  # Returns the number of mines that are surrounding this cell (maximum of 8).
  def adjacent_mines(row, col)
    mine_count = 0
    adjacents = get_adjacents(row, col)
    adjacents.each do |coord|
      if contains_mine?(coord[0], coord[1])
        mine_count += 1
      end
    end
    mine_count
  end

  # Returns true if the given cell contains a mine, false otherwise.
  def contains_mine?(row, col)
    @minefield[row][col] == 6 || @minefield[row][col] == 9
  end
end
