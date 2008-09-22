class Symbol
  
  def method_missing(sym, *args)
    self.to_s.send(sym, *args)
  end
  
  # See Mack::ViewHelpers::FormHelpers date_time_select for more information
  def date_time_select(*args)
    Thread.current[:view_template].date_time_select(self, *args)
  end
  
  # See Mack::ViewHelpers::FormHelpers date_select for more information
  def date_select(*args)
    Thread.current[:view_template].date_select(self, *args)
  end
  
  # See Mack::ViewHelpers::FormHelpers check_box for more information
  # 
  # Examples:
  #   @user = User.new(:accepted_tos => true)
  #   <%= :user.check_box :accepted_tos %> # => <input checked="checked" id="user_accepted_tos" name="user[accepted_tos]" type="checkbox" />
  #   <%= :i_dont_exist.check_box %> # => <input id="i_dont_exist" name="i_dont_exist" type="checkbox" />
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
  
  # See Mack::ViewHelpers::FormHelpers label_tag for more information
  # 
  # Examples:
  #   @user = User.new
  #   <%= :user.label_tag :email %> # => <label for="user_email">Email</label>
  #   <%= :i_dont_exist.label_tag %> # => <label for="i_dont_exist">I don't exist</label>
  #   <%= :i_dont_exist.label_tag :value => "Hello" %> # => <label for="i_dont_exist">Hello</label>
  def label_tag(*args)
    Thread.current[:view_template].label_tag(self, *args)
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
  # 
  # Examples:
  #   @user = User.new(:level => 1)
  #   <%= :user.radio_button :level %> # => <input checked="checked" id="user_level" name="user[level]" type="radio" value="1" />
  #   <%= :user.radio_button :level, :value => 2 %> # => <input id="user_level" name="user[level]" type="radio" value="2" />
  #   <%= :i_dont_exist.radio_button %> # => <input id="i_dont_exist" name="i_dont_exist" type="radio" value="" />
  def radio_button(*args)
    Thread.current[:view_template].radio_button(self, *args)
  end
  
  # See Mack::ViewHelpers::FormHelpers select_tag for more information
  # 
  # Examples:
  #   @user = User.new(:level => 1)
  #   <%= :user.select_tag :level, :options => [["one", 1], ["two", 2]] %> # => <select id="user_level" name="user[level]"><option value="1" selected>one</option><option value="2" >two</option></select>
  #   <%= :user.select_tag :level, :options => {:one => 1, :two => 2} %> # => <select id="user_level" name="user[level]"><option value="1" selected>one</option><option value="2" >two</option></select>
  #   <%= :i_dont_exist.select_tag :options => [["one", 1], ["two", 2]], :selected => 1 %> # => <select id="i_dont_exist" name="i_dont_exist"><option value="1" selected>one</option><option value="2" >two</option></select>
  def select_tag(*args)
    Thread.current[:view_template].select_tag(self, *args)
  end
  
  # See Mack::ViewHelpers::FormHelpers text_area for more information
  # 
  # Examples:
  #   @user = User.new(:bio => "my bio here")
  #   <%= :user.text_area :bio %> # => <textarea id="user_bio" name="user[bio]">my bio here</textarea>
  #   <%= :i_dont_exist.text_area %> # => <textarea id="i_dont_exist" name="i_dont_exist"></textarea>
  #   <%= :i_dont_exist.text_area :value => "hi there" %> # => <textarea id="i_dont_exist" name="i_dont_exist">hi there</textarea>
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