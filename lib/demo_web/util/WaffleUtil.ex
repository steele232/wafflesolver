defmodule DemoWeb.Util.WaffleUtil do

  @spec color_atom_to_bulma_color_class(:green | :grey | :yellow) :: String.t()
  def color_atom_to_bulma_color_class(color_atom) do
    case color_atom do
      :green -> "button is-success"
      :yellow -> "button is-warning"
      :grey -> "button"
    end
  end

  @spec cycle_color_atom(:green | :grey | :yellow) :: :green | :grey | :yellow
  def cycle_color_atom(color_atom) do
    case color_atom do
      :green -> :yellow
      :yellow -> :grey
      :grey -> :green
    end
  end
end
