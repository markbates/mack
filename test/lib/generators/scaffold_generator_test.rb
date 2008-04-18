require File.dirname(__FILE__) + '/../../test_helper.rb'

class ScaffoldGeneratorTest < Test::Unit::TestCase
  
  def setup
    @routes = File.open(File.join(MACK_CONFIG, "routes.rb")).read
    cleanup
  end
  
  def teardown
    cleanup
    File.open(File.join(MACK_CONFIG, "routes.rb"), "w") do |f|
      f.puts @routes
    end
  end
  
  def test_generate_active_record
    use_active_record do
      orm_common
      cont = <<-CONT
class ZoosController < Mack::Controller::Base

  # GET /zoos
  def index
    @zoos = Zoo.find(:all)
  end

  # GET /zoos/1
  def show
    @zoo = Zoo.find(params(:id))
  end

  # GET /zoos/new
  def new
    @zoo = Zoo.new
  end

  # GET /zoos/1/edit
  def edit
    @zoo = Zoo.find(params(:id))
  end

  # POST /zoos
  def create
    @zoo = Zoo.new(params(:zoo))
    if @zoo.save
      redirect_to(zoos_show_url(:id => @zoo.id))
    else
      render(:action => "new")
    end
  end

  # PUT /zoos/1
  def update
    @zoo = Zoo.find(params(:id))
    if @zoo.update_attributes(params(:zoo))
      redirect_to(zoos_show_url(:id => @zoo.id))
    else
      render(:action => "edit")
    end
  end

  # DELETE /zoos/1
  def delete
    @zoo = Zoo.find(params(:id))
    @zoo.destroy
    redirect_to(zoos_index_url)
  end

end
CONT
      assert_equal cont, File.open(controller_file).read
      
      mod = <<-MOD
class Zoo < ActiveRecord::Base
end
MOD
      assert_equal mod, File.open(model_file).read
    end
  end
  
  def test_generate_data_mapper
    use_data_mapper do
      orm_common
            cont = <<-CONT
class ZoosController < Mack::Controller::Base

  # GET /zoos
  def index
    @zoos = Zoo.find(:all)
  end

  # GET /zoos/1
  def show
    @zoo = Zoo.find(params(:id))
  end

  # GET /zoos/new
  def new
    @zoo = Zoo.new
  end

  # GET /zoos/1/edit
  def edit
    @zoo = Zoo.find(params(:id))
  end

  # POST /zoos
  def create
    @zoo = Zoo.new(params(:zoo))
    if @zoo.save
      redirect_to(zoos_show_url(:id => @zoo.id))
    else
      render(:action => "new")
    end
  end

  # PUT /zoos/1
  def update
    @zoo = Zoo.find(params(:id))
    if @zoo.update_attributes(params(:zoo))
      redirect_to(zoos_show_url(:id => @zoo.id))
    else
      render(:action => "edit")
    end
  end

  # DELETE /zoos/1
  def delete
    @zoo = Zoo.find(params(:id))
    @zoo.destroy!
    redirect_to(zoos_index_url)
  end

end
CONT
      assert_equal cont, File.open(controller_file).read
      
      mod = <<-MOD
class Zoo < DataMapper::Base
end
MOD
      assert_equal mod, File.open(model_file).read
    end
  end
  
  def test_generate_data_mapper_with_columns
    use_data_mapper do
      orm_common_with_cols
    end
  end
  
  def test_generate_active_record_with_columns
    use_active_record do
      orm_common_with_cols
    end
  end
  
  def test_generate_no_orm
    temp_app_config("orm" => nil) do
      sg = ScaffoldGenerator.new("name" => "zoo")
      sg.run
      File.open(File.join(MACK_CONFIG, "routes.rb")) do |f|
        assert_match "r.resource :zoos # Added by rake generate:scaffold name=zoo", f.read
      end
      assert File.exists?(controller_file)
      assert !File.exists?(views_dir)
      cont = <<-CONT
class ZoosController < Mack::Controller::Base

  # GET /zoos
  def index
    "Zoos#index"
  end

  # POST /zoos
  def create
    "Zoos#create"
  end

  # GET /zoos/new
  def new
    "Zoos#new"
  end

  # GET /zoos/1
  def show
    "Zoos#show id: \#{params(:id)}"
  end

  # GET /zoos/1/edit
  def edit
    "Zoos#edit id: \#{params(:id)}"
  end

  # PUT /zoos/1
  def update
    "Zoos#update id: \#{params(:id)}"
  end

  # DELETE /zoos/1
  def delete
    "Zoos#delete"
  end

end
CONT
      assert_equal cont, File.open(controller_file).read
    end
  end
  
  private
  
  def orm_common_with_cols
    sg = ScaffoldGenerator.new("name" => "zoo", "cols" => "name:string,description:text")
    sg.run
    File.open(File.join(MACK_CONFIG, "routes.rb")) do |f|
      assert_match "r.resource :zoos # Added by rake generate:scaffold name=zoo", f.read
    end
    assert File.exists?(views_dir)
    edit_erb = <<-ERB
<h1>Edit Zoo</h1>

<%= error_messages_for :zoo %>

<form action="<%= zoos_update_url(:id => @zoo.id) %>" class="edit_zoo" id="edit_zoo" method="zoo">
  <input type="hidden" name="_method" value="put">
  <p>
    <b>Name</b><br />
    <input type="text" name="zoo[name]" id="zoo_name" size="30" value="<%= @zoo.name %>" />
  </p>
  <p>
    <b>Description</b><br />
    <textarea name="zoo[description]" id="zoo_description"><%= @zoo.description %></textarea>
  </p>
  <p>
    <input id="zoo_submit" name="commit" type="submit" value="Create" />
  </p>
</form>

<%= link_to("Back", zoos_index_url) %>
ERB
    assert_equal edit_erb, File.open(File.join(views_dir, "edit.html.erb")).read

    index_erb = <<-ERB
<h1>Listing Zoos</h1>

<table>
  <tr>
    <th>Name</th>
    <th>Description</th>
  </tr>

<% for zoo in @zoos %>
  <tr>
    <td><%= zoo.name %></td>
    <td><%= zoo.description %></td>
    <td><%= link_to("Show", zoos_show_url(:id => zoo.id)) %></td>
    <td><%= link_to("Edit", zoos_edit_url(:id => zoo.id)) %></td>
    <td><%= link_to("Delete", zoos_delete_url(:id => zoo.id), :method => :delete, :confirm => "Are you sure?") %></td>
  </tr>
<% end %>
</table>

<br />

<%= link_to("New Zoo", zoos_new_url) %>
ERB

    assert_equal index_erb, File.open(File.join(views_dir, "index.html.erb")).read

    new_erb = <<-ERB
<h1>New Zoo</h1>

<%= error_messages_for :zoo %>

<form action="<%= zoos_create_url %>" class="new_zoo" id="new_zoo" method="zoo">
  <p>
    <b>Name</b><br />
    <input type="text" name="zoo[name]" id="zoo_name" size="30" value="<%= @zoo.name %>" />
  </p>
  <p>
    <b>Description</b><br />
    <textarea name="zoo[description]" id="zoo_description"><%= @zoo.description %></textarea>
  </p>
  <p>
    <input id="zoo_submit" name="commit" type="submit" value="Create" />
  </p>
</form>

<%= link_to("Back", zoos_index_url) %>
ERB
    assert_equal new_erb, File.open(File.join(views_dir, "new.html.erb")).read

    show_erb = <<-ERB
<p>
  <h1>Zoo</h1>
</p>
<p>
  <b>Name</b><br />
  <%= @zoo.name %>
</p>
<p>
  <b>Description</b><br />
  <%= @zoo.description %>
</p>

<%= link_to("Edit", zoos_edit_url(:id => @zoo.id)) %> |
<%= link_to("Back", zoos_index_url) %>
ERB

    assert_equal show_erb, File.open(File.join(views_dir, "show.html.erb")).read

    assert File.exists?(model_file)
    assert File.exists?(controller_file)
    assert File.exists?(migration_file)
  end
  
  def orm_common
    sg = ScaffoldGenerator.new("name" => "zoo")
    sg.run
    File.open(File.join(MACK_CONFIG, "routes.rb")) do |f|
      assert_match "r.resource :zoos # Added by rake generate:scaffold name=zoo", f.read
    end
    
    assert File.exists?(views_dir)
    edit_erb = <<-ERB
<h1>Edit Zoo</h1>

<%= error_messages_for :zoo %>

<form action="<%= zoos_update_url(:id => @zoo.id) %>" class="edit_zoo" id="edit_zoo" method="zoo">
  <input type="hidden" name="_method" value="put">
  <p>
    <input id="zoo_submit" name="commit" type="submit" value="Create" />
  </p>
</form>

<%= link_to("Back", zoos_index_url) %>
ERB
    assert_equal edit_erb, File.open(File.join(views_dir, "edit.html.erb")).read
    
    index_erb = <<-ERB
<h1>Listing Zoos</h1>

<table>
  <tr>
    <th>&nbsp;</th>
  </tr>

<% for zoo in @zoos %>
  <tr>
    <td>&nbsp;</td>
    <td><%= link_to("Show", zoos_show_url(:id => zoo.id)) %></td>
    <td><%= link_to("Edit", zoos_edit_url(:id => zoo.id)) %></td>
    <td><%= link_to("Delete", zoos_delete_url(:id => zoo.id), :method => :delete, :confirm => "Are you sure?") %></td>
  </tr>
<% end %>
</table>

<br />

<%= link_to("New Zoo", zoos_new_url) %>
ERB
    assert_equal index_erb, File.open(File.join(views_dir, "index.html.erb")).read
    
    new_erb = <<-ERB
<h1>New Zoo</h1>

<%= error_messages_for :zoo %>

<form action="<%= zoos_create_url %>" class="new_zoo" id="new_zoo" method="zoo">
  <p>
    <input id="zoo_submit" name="commit" type="submit" value="Create" />
  </p>
</form>

<%= link_to("Back", zoos_index_url) %>
ERB
    assert_equal new_erb, File.open(File.join(views_dir, "new.html.erb")).read
    
    show_erb = <<-ERB
<p>
  <h1>Zoo</h1>
</p>

<%= link_to("Edit", zoos_edit_url(:id => @zoo.id)) %> |
<%= link_to("Back", zoos_index_url) %>
ERB
    assert_equal show_erb, File.open(File.join(views_dir, "show.html.erb")).read
    
    assert File.exists?(model_file)
    assert File.exists?(controller_file)
    assert File.exists?(migration_file)
  end
  
  def views_dir
    File.join(MACK_VIEWS, "zoos")
  end
  
  def model_file
    File.join(MACK_APP, "models", "zoo.rb")
  end
  
  def controller_file
    File.join(MACK_APP, "controllers", "zoos_controller.rb")
  end
  
  def migration_file
    File.join(migration_dir, "001_create_zoos.rb")
  end
  
  def migration_dir
    File.join(MACK_ROOT, "db", "migrations")
  end
  
  def cleanup
    if File.exists?(migration_dir)
      FileUtils.rm_r(migration_dir)
    end
    
    if File.exists?(views_dir)
      FileUtils.rm_r(views_dir)
    end

    if File.exists?(model_file)
      FileUtils.rm_r(model_file)
    end

    if File.exists?(controller_file)
      FileUtils.rm_r(controller_file)
    end
  end
  
end