# frozen_string_literal: true

class PasswordValidator
    def initialize(file_path)
        @file_path = file_path
        @parsed_data = []
    end

    def call
        @parsed_data = parse_file
        valid_passwords
    end

    def parse_file
        # Parse the file and split each line into logical parts - Letter, Range, Password
        @parsed_data = File.open(@file_path).map do |line|
            next if line.strip.empty?

            letter, range, password = line.match(/(\w)\s(\d+-\d+):\s(\w+)/).captures
            range_arr = range.split('-')
            range = Range.new(range_arr[0].to_i, range_arr[1].to_i)
            { letter: letter, range: range, password: password }
        end.compact
    end

    def valid_passwords
        # The search for valid passwords works according to the following algorithm:
            # 1. Check how many times the specified letter is included in the password
            # 2. Check if the number of occurrences of the letter is in the specified range
        valid_passwords = @parsed_data.select do |data|
            (data[:range].include?(data[:password].count(data[:letter])))
        end

        # This part of the method is needed only to nicely show the results
        puts "Number of valid passwords is: #{valid_passwords.size}"
        puts "\nValid passwords are::\n"
        valid_passwords.each { |data| puts data[:password] }
    end
end

PasswordValidator.new('test.txt').call
