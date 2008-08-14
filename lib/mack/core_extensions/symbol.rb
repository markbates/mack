class Symbol
  
  # See Mack::ViewHelpers::FormHelpers check_box for more information
  # 
  # Examples:
  #   @user = User.new(:accepted_tos => true)
  #   <%= :user.check_box :accepted_tos %> # => <input checked="checked" id="user_accepted_tos" name="user[accepted_tos]" type="checkbox" />
  #   <%= :i_dont_exist.checkbox %> # => <input id="i_dont_exist" name="i_dont_exist" type="checkbox" />
  def check_box(*args)
    Thread.current[:view_template].check_box(self, *args)
  end
  
  # See Mack::ViewHelpers::FormHelpers file_field for more information
  # 
  # Examples:
  #   @user = User.new(:bio_file => "~/bio.doc")
  #   <%= :user.file_field :bio_file %> # => <input id="user_bio_field" name="user[bio_field]" type="file" value="~/bio.doc" />
  #   <%= :i_dont_exist.file_field %> # => <input id="i_dont_exist" name="i_dont_exist" type="file" value="" />
  def file_field(*args)
    Thread.current[:view_template].file_field(self, *args)
  end
  
  # See Mack::ViewHelpers::FormHelpers hidden_field for more information
  # 
  # Examples:
  #   @user = User.new(:email => "mark@mackframework.com")
  #   <%= :user.hidden_field :email %> # => <input id="user_email" name="user[email]" type="hidden" value="mark@mackframework.com" />
  #   <%= :i_dont_exist.hidden_field %> # => <input id="i_dont_exist" name="i_dont_exist" type="hidden" />
  def hidden_field(*args)
    Thread.current[:view_template].hidden_field(self, *args)
  end
  
  # See Mack::ViewHelpers::FormHelpers image_submit for more information
  def image_submit(*args)
    Thread.current[:view_template].image_submit(self, *args)
  end
  
  # See Mack::ViewHelpers::FormHelpers label_tag for more information
  def label_tag(*args)
    Thread.current[:view_template].label(self, *args)
  end
  
  # See Mack::ViewHelpers::FormHelpers password_field for more information
  # 
  # Examples:
  #   @user = User.new(:email => "mark@mackframework.com")
  #   <%= :user.password_field :email %> # => <input id="user_email" name="user[email]" type="password" value="mark@mackframework.com" />
  #   <%= :i_dont_exist.password_field %> # => <input id="i_dont_exist" name="i_dont_exist" type="password" />
  def password_field(*args)
    Thread.current[:view_template].password_field(self, *args)
  end
  
  # See Mack::ViewHelpers::FormHelpers radio_button for more information
  def radio_button(*args)
    Thread.current[:view_template].radio_button(self, *args)
  end
  
  # See Mack::ViewHelpers::FormHelpers select for more information
  def select(*args)
    Thread.current[:view_template].select(self, *args)
  end
  
  # See Mack::ViewHelpers::FormHelpers submit for more information
  def submit(*args)
    Thread.current[:view_template].submit(self, *args)
  end
  
  # See Mack::ViewHelpers::FormHelpers text_area for more information
  def text_area(*args)
    Thread.current[:view_template].text_area(self, *args)
  end
  
  # See Mack::ViewHelpers::FormHelpers text_field for more information
  # 
  # Examples:
  #   @user = User.new(:email => "mark@mackframework.com")
  #   <%= :user.text_field :email %> # => <input id="user_email" name="user[email]" type="text" value="mark@mackframework.com" />
  #   <%= :i_dont_exist.text_field %> # => <input id="i_dont_exist" name="i_dont_exist" type="text" />
  def text_field(*args)
    Thread.current[:view_template].text_field(self, *args)
  end
  
end