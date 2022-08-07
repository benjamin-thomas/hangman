defmodule B1Web.PageView do
  use B1Web, :view

  def pluralize(1, singular, _plural), do: "one #{singular}"

  def pluralize(count, _singular, plural) do
    if count < 0 do
      """
      <span style="color:red">
      #{count} #{plural}
      </span>
      """
      |> raw()
    else
      "#{count} #{plural}"
    end
  end
end
