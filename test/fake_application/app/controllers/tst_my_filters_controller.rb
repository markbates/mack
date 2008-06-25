class TstMyFiltersController
  include Mack::Controller
  
  before_filter :set_date
  before_filter :say_hi, :only => :hello
  before_filter :say_goodbye, :except => :hello
  before_filter :im_bad, :only => :please_blow_up
  
  after_filter :clean_me_up, :only => :me
  
  after_render_filter :make_everything_a, :only => :make_all_a
  
  def index
    render(:text, "Date: #{@date}; Hi: '#{@hi}'; Goodbye: '#{@goodbye}'")
  end
  
  def hello
    render(:text, "Hi: '#{@hi}'; Goodbye: '#{@goodbye}'")
  end
  
  def please_blow_up
    render(:text, "You should never see me!")
  end
  
  def me
    @me = "me"
  end
  
  def make_all_a
    render(:text, "i'm big")
  end
  
  protected
  def make_everything_a
    @final_rendered_action.gsub!(/./, "a")
  end
  
  def clean_me_up
    @me = @me.upcase
  end
  
  def im_bad
    false
  end
  
  def set_date
    @date = "TODAY!"
  end
  
  def say_hi
    @hi = "HELLO!!"
  end
  
  def say_goodbye
    @goodbye = "bye!"
  end
  
end