class Pet
  attr_accessor :name, :species, :id

  def initialize(attr) # attr will be a hash
    self.name = attr["name"]
    self.species = attr["species"]
    self.id = attr["id"]
  end

  def save
    pet = Pet.find_by(self.name, self.species)

    if pet
      pet.update({"name" => self.name, "species" => self.species})
    else
      sql = <<-SQL
        INSERT INTO pets (name, species)
        VALUES (?, ?);
      SQL

      DB[:conn].execute(sql, self.name, self.species)

      # we want to save Sammy (or any other pet) to the database with it's attributes
      sql = <<-SQL
        SELECT id FROM pets
        ORDER BY id DESC
        LIMIT 1;
      SQL

      id = DB[:conn].execute(sql)[0]["id"]

      self.id = id
    end
    # then we want to grab the id of that record in order to update this instance
  end

  def self.find_by(name, species)
    sql = <<-SQL
      SELECT * FROM pets
      WHERE name = ? AND species = ?;
    SQL

    attr = DB[:conn].execute(sql, name, species)
    if !attr.empty?
      Pet.new(attr[0])
    end
  end

  def self.create(attr)
    pet = self.new(attr)
    pet.save
    pet
  end

  def update(attr)
    attr.each do |key, value|
      self.send("#{key}=", value)        
    end

    if self.id
      sql = <<-SQL
        UPDATE pets
        SET name = ?, species = ?
        WHERE id = ?
      SQL

      DB[:conn].execute(sql, self.name, self.species, self.id)
    else
      self.save
    end
  end

  def self.find(id)
    sql = <<-SQL
      SELECT * FROM pets
      WHERE id = ?
    SQL

    attr = DB[:conn].execute(sql, id)[0]
    
    Pet.new(attr)
  end

  def self.all
    # we want to select all of our pets

    sql = <<-SQL
      SELECT * FROM pets;
    SQL

    data = DB[:conn].execute(sql)

    data.map do |attr|
      Pet.new(attr)
    end
  end
end