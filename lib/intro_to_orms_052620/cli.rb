class CLI
  attr_accessor :current_user

  def run
    puts "Welcome to the Pet Shop!"
    login
    menu_options
  end

  def login
    puts "What is your name?"
    name = gets.strip
    owner = Owner.find_or_create_by(name: name)
    unless owner
      display_errors(owner.errors.full_messages)
      login
    else
      self.current_user = owner
    end
  end

  def menu_options
    puts "Type 'create' to create a pet"
    puts "Type 'list' to list pets"
    puts "Type 'exit' to exit program"
    menu_input
  end

  def menu_input
    input = gets.strip
    if input.downcase == 'create'
      # create pet
      create_pet
      menu_options
    elsif input.downcase == 'list'
      list_pets
      menu_options
    elsif input.downcase == 'exit'
      goodbye
      exit
    else
      invalid_choice
      menu_options
    end
  end

  def create_pet
    puts "What is your pet's name?"
    name = gets.strip
    puts "What is your pet's species?"
    
    species = gets.strip
    pet = Pet.new(name: name, species: species, owner: self.current_user)
    unless pet.save
      display_errors(pet.errors.full_messages)
      puts "please try again"
      create_pet
    else
      puts "#{pet.name} has been successfully created."
    end
  end

  def display_errors(error_messages)
    error_messages.each do |error|
      puts error
    end
  end

  def list_pets
    self.current_user.reload
    self.current_user.pets.each.with_index(1) do |pet, index|
      puts "#{index}. #{pet.name} who is a #{pet.species}"
    end
  end

  def goodbye
    puts "Thank you for shopping at the pet shop. Come again!"
  end

  def invalid_choice
    puts "Ooooo noooo. You typed something wrong. Try again!"
  end
end