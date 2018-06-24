# frozen_string_literal: true

namespace :character do
  desc 'Assign Father and Mother characters from names in correspondant fields'
  task establish_parenthood_association: :environment do
    puts 'Working...!'
    results = Character.establish_parenthood_association_for_all_characters
    puts 'Done! Printing results'
    puts results
  end
end
