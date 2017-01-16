defmodule <%= app_module %>.<%= resource_name %>View do
  use <%= app_module %>.Web, :view

  def render("show.json", %{<%= String.downcase(resource_name) %>: <%= String.downcase(resource_name) %>}) do
    %{data: render_one(<%= String.downcase(resource_name) %>, <%= app_module %>.<%= resource_name %>View, "<%= String.downcase(resource_name) %>.json")}
  end

  def render("<%= String.downcase(resource_name) %>.json", %{<%= String.downcase(resource_name) %>: <%= String.downcase(resource_name) %>}) do
    %{id: <%= String.downcase(resource_name) %>.id,
      email: <%= String.downcase(resource_name) %>.email}
  end
end
