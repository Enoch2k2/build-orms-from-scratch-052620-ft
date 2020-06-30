class CLI
  def run
    puts "Welcome to the Pet Shop!"
    menu_options
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
    puts "What is the pet's name?"
    name = gets.strip
    puts "What is the pet's species?"
    
    species = gets.strip

    pet = Pet.create(name: name, species: species)
    puts "#{pet.name} has been successfully created."
  end

  def list_pets
    Pet.all.each.with_index(1) do |pet, index|
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