require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    stu = self.new
    stu.id = row[0]
    stu.name = row[1]
    stu.grade = row[2]
    stu
  end

  def self.all

    sql = <<-SQL
      SELECT * FROM students
    SQL

    DB[:conn].execute(sql).map {|data_base_row| self.new_from_db(data_base_row)}
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ? LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map {|data_base_row| self.new_from_db(data_base_row)}
    # find the student in the database given a name
    # return a new instance of the Student class
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
