require_relative '../init'

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
  attr_reader :email, :alt_email_1, :alt_email_2, :id

  def initialize(email, alt_email_1 = nil, alt_email_2 = nil, id = nil)
    @primary_email = email
    @alt_email_1 = alt_email_1
    @alt_email_2 = alt_email_2
    @id = id
  end

  def add_to_db
    db.execute <<-SQL
    INSERT INTO users
    ('primary_email', 'alt_email_1', 'alt_email_2', 'created_at', 'updated_at')
    VALUES ("#{@primary_email}", "#{@alt_email_1}", "#{@alt_email_2}",
    DATETIME('now'), DATETIME('now'))
    SQL
    set_user_id####
  end

  def set_user_id
    @id = db.execute("SELECT MAX(id) FROM users")[0][0]
  end

end