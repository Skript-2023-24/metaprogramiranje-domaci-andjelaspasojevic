require "google_drive"
session = GoogleDrive::Session.from_config("config.json")

ws = session.spreadsheet_by_key("1VNysfQaFUH8OnbKM9NUb6ua5pVrhXgr50vGcTAwsA7c").worksheets[0]
ws1 = session.spreadsheet_by_key("1VNysfQaFUH8OnbKM9NUb6ua5pVrhXgr50vGcTAwsA7c").worksheets[1]

table_values = []
start_row = nil
start_col = nil

(1..ws.num_rows).each do |row|
  (1..ws.num_cols).each do |col|
    cell_value = ws[row, col]
    if cell_value && !cell_value.empty?
      start_row = row
      start_col = col
      break
    end
  end
  break if start_row
end

(start_row..ws.num_rows).each do |row|
  row_values = []
  (start_col..ws.num_cols).each do |col|
    row_values << ws[row, col]
  end
  table_values << row_values
end

table_values1 = []
start_row1 = nil
start_col1 = nil

(1..ws1.num_rows).each do |row1|
  (1..ws1.num_cols).each do |col1|
    cell_value1 = ws1[row1, col1]
    if cell_value1 && !cell_value1.empty?
      start_row1 = row1
      start_col1 = col1
      break
    end
  end
  break if start_row1
end

(start_row1..ws1.num_rows).each do |row1|
  row_values1 = []
  (start_col1..ws1.num_cols).each do |col1|
    row_values1 << ws1[row1, col1]
  end
  table_values1 << row_values1
end

class Table
  include Enumerable

  def initialize(value)
    @value = value
  end

  def get
    @value
  end

  def row(index)
    @value[index]
  end

  def each
    @value.each do |row|
      row.each do |cell|
        yield cell
      end
    end
  end

  def [](col_name)
    col_index = @value.first.index(col_name)
    if col_index
      @value.transpose[col_index].drop(1)
    else
      puts "Nema takve kolone!"
    end
  end
end

t1 = Table.new(table_values)
t2 = Table.new(table_values1)

# Odavde kreće main (testiranje)

puts "1. zadatak"
p t1.get

puts "2. zadatak"
third_row = t1.row(2)
puts "Treći red: #{third_row}"
third_element = t1.row(2)[2]
puts "Treći element trećeg reda: #{third_element}"

puts "3. zadatak"
puts "Sve ćelije iz tabele:"
t1.each do |element|
  puts "\"#{element}\" "
end

puts "4. zadatak"
p t1.get

puts "5. zadatak"
third_col = t1["Treca kolona"]
puts "Treća kolona: #{third_col}"
second_el_of_third_col = t1["Treca kolona"][1]
puts "Drugi element treće kolone: #{second_el_of_third_col}"
t1["Treca kolona"][1] = 56
second_el_of_third_col = t1["Treca kolona"][1]
puts "Drugi element treće kolone posle izmene: #{second_el_of_third_col}"