class Symbol
  
  def check_box(*args)
    Thread.current[:view_template].check_box(self, *args)
  end
  
  def file_field(*args)
    Thread.current[:view_template].file_field(self, *args)
  end
  
  def hidden_field(*args)
    Thread.current[:view_template].hidden_field(self, *args)
  end
  
  def image_submit(*args)
    Thread.current[:view_template].image_submit(self, *args)
  end
  
  def label(*args)
    Thread.current[:view_template].label(self, *args)
  end
  
  def radio_button(*args)
    Thread.current[:view_template].radio_button(self, *args)
  end
  
  def select(*args)
    Thread.current[:view_template].select(self, *args)
  end
  
  def submit(*args)
    Thread.current[:view_template].submit(self, *args)
  end
  
  def text_area(*args)
    Thread.current[:view_template].text_area(self, *args)
  end
  
  def text_field(*args)
    Thread.current[:view_template].text_field(self, *args)
  end
  
end