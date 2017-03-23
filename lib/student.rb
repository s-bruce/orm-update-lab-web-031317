require_relative "../config/environment.rb"

class Student

	attr_accessor :name, :grade, :id

	def initialize(name, grade, id=nil)
  	@name = name
  	@grade = grade
  	@id = id
  end

  def self.create_table
  	sql = <<-SQL 
  			CREATE TABLE IF NOT EXISTS students (
  			id INTEGER PRIMARY KEY,
  			name TEXT,
  			grade TEXT );
  			SQL
  	DB[:conn].execute(sql)
  end

  def self.drop_table
  	sql= <<-SQL 
  		DROP TABLE students;
  		SQL
  	DB[:conn].execute(sql)
  	end

  def save
  	if (self.id)
  		self.update
  	else
  	sql = <<-SQL
  			INSERT INTO students(name, grade) VALUES (?, ?);
  			SQL
  	DB[:conn].execute(sql, self.name, self.grade)
  	self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end
  end

  def update
  	#self.name = "Jane Smith"
  	sql = <<-SQL
  			UPDATE students SET name = ? WHERE id = ?;
  			SQL
  	DB[:conn].execute(sql, self.name, self.id)
  end

  def self.create(name, grade)
  	student = Student.new(name, grade)
  	student.save
  	student
  end

  def self.new_from_db(row)
  	student = Student.new(row[1], row[2], row[0])
  end

  def self.find_by_name(name)
  	sql = <<-SQL 
  			SELECT * FROM students WHERE name = ?;
  			SQL
  	results = DB[:conn].execute(sql, name)
  	new_from_db(results[0])

  end

end
