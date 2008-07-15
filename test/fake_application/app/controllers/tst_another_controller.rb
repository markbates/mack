class TstAnotherController
  include Mack::Controller
  include Mack::ViewHelpers::ApplicationHelper
  
  def foo
    render(:text, "tst_another_controller: foo: id: '#{params[:id]}' pickles: '#{params[:pickles]}'")
  end
  
  def bar
    render(:text, %{
      <form action="<%= pickles_url %>" method="post">
        <input type="text" name="id"/ ><br>
        <textarea name="pickles"></textarea><br>
        <input type="submit" name="submit">
      </form>
    })
  end
  
  def show_all_params
    render(:text, request.all_params)
  end
  
  def act_level_layout_test_action
    render(:text, "I've changed the layout in the action!", :layout => :my_super_cool)
  end
  
  def layout_set_to_nil_in_action
    render(:text, "I've set my layout to nil!", :layout => nil)
  end
  
  def layout_set_to_false_in_action
    render(:text, "I've set my layout to false!", :layout => false)
  end
  
  def layout_set_to_unknown_in_action
    render(:text, "I've set my layout to some layout that don't exist!", :layout => :i_dont_exist)
  end
  
  def env
    render(:text, "Mack.env: #{Mack.env}")
  end
  
  def kill_kenny_bad
    render(:text, kill_kenny)
  end
  
  def say_love_you
    render(:text, love_you)
  end
  
  def regardless_of_string_or_symbol
    x = ""
    x << "from_string: foo=#{params["foo"]}\n"
    x << "from_symbol: foo=#{params[:foo]}\n"
    render(:text, x)
  end
  
  def params_return_as_hash
    @foo = params[:foo]
    x = ""
    x << "class: #{params[:foo].class}]\n"
    x << "inspect: #{params[:foo].inspect}"
    render(:text, x)
  end
  
end