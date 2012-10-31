require '../init'

class User
  include Initializer
  # user can enter email
  # user needs to enter a matching password
  # user enters the desired frequency
  # a cron job will reference the usr table for the email address and frequency of email sends
  #
  # *********
  # user can have multiple addresses
  # user can change the frequency of the emails they receive
  attr_reader :email, :password, :digest_frequency, :alt_email_1, :alt_email_2

  def initialize(email, password, digest_frequency, alt_email_1 = nil, alt_email_2 = nil)
    @primary_email = email
    @password =password
    @digest_frequency = digest_frequency
    @alt_email_1 = alt_email_1
    @alt_email_2 = alt_email_2
  end

  def add_to_db
    db.execute <<-SQL
    INSERT INTO users
    ('primary_email', 'password', 'digest_frequency', 'alt_email_1', 'alt_email_2', 'created_at', 'updated_at')
    VALUES ("#{@primary_email}", "#{@password}", "#{@digest_frequency}", "#{@alt_email_1}", "#{@alt_email_2}",
    DATETIME('now'), DATETIME('now'))
    SQL
  end


end

# testing information
billy = User.new("mail@bonnefil.com", "testerpassword", 5, "stuff@bonnefil.com")
billy.add_to_db