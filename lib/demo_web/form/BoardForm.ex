defmodule DemoWeb.BoardForm do
  alias DemoWeb.BoardSquareForm
  alias DemoWeb.BoardForm
  alias DemoWeb.Util.WaffleUtil

  # is_intersection is permanent, feedbacks will change based on user input
  defstruct v1h1: %BoardSquareForm{ is_intersection: false, feedback_color: :green, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:green) },
    v1h2: %BoardSquareForm{ is_intersection: false, feedback_color: :grey, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:grey) },
    v1h3: %BoardSquareForm{ is_intersection: true, feedback_color: :grey, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:grey) },
    v1h4: %BoardSquareForm{ is_intersection: false, feedback_color: :grey, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:grey) },
    v1h5: %BoardSquareForm{ is_intersection: false, feedback_color: :green, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:green) },
    v2h1: %BoardSquareForm{ is_intersection: false, feedback_color: :grey, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:grey) },
    v2h3: %BoardSquareForm{ is_intersection: false, feedback_color: :grey, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:grey) },
    v2h5: %BoardSquareForm{ is_intersection: false, feedback_color: :grey, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:grey) },
    v3h1: %BoardSquareForm{ is_intersection: true, feedback_color: :grey, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:grey) },
    v3h2: %BoardSquareForm{ is_intersection: false, feedback_color: :grey, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:grey) },
    v3h3: %BoardSquareForm{ is_intersection: true, feedback_color: :grey, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:grey) },
    v3h4: %BoardSquareForm{ is_intersection: false, feedback_color: :grey, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:grey) },
    v3h5: %BoardSquareForm{ is_intersection: true, feedback_color: :grey, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:grey) },
    v4h1: %BoardSquareForm{ is_intersection: false, feedback_color: :grey, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:grey) },
    v4h3: %BoardSquareForm{ is_intersection: false, feedback_color: :grey, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:grey) },
    v4h5: %BoardSquareForm{ is_intersection: false, feedback_color: :grey, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:grey) },
    v5h1: %BoardSquareForm{ is_intersection: false, feedback_color: :green, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:green) },
    v5h2: %BoardSquareForm{ is_intersection: false, feedback_color: :grey, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:grey) },
    v5h3: %BoardSquareForm{ is_intersection: true, feedback_color: :grey, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:grey) },
    v5h4: %BoardSquareForm{ is_intersection: false, feedback_color: :grey, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:grey) },
    v5h5: %BoardSquareForm{ is_intersection: false, feedback_color: :green, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:green) }

  def fromLettersMap(
    %{
      "v1h1" => v1h1,
      "v1h2" => v1h2,
      "v1h3" => v1h3,
      "v1h4" => v1h4,
      "v1h5" => v1h5,
      "v2h1" => v2h1,
      "v2h3" => v2h3,
      "v2h5" => v2h5,
      "v3h1" => v3h1,
      "v3h2" => v3h2,
      "v3h3" => v3h3,
      "v3h4" => v3h4,
      "v3h5" => v3h5,
      "v4h1" => v4h1,
      "v4h3" => v4h3,
      "v4h5" => v4h5,
      "v5h1" => v5h1,
      "v5h2" => v5h2,
      "v5h3" => v5h3,
      "v5h4" => v5h4,
      "v5h5" => v5h5
    } = _paramMap) do

      %BoardForm{
        v1h1: %BoardSquareForm{ character: v1h1, is_intersection: false, feedback_color: :green, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:green) },
        v1h2: %BoardSquareForm{ character: v1h2, is_intersection: false, feedback_color: :grey, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:grey) },
        v1h3: %BoardSquareForm{ character: v1h3, is_intersection: true, feedback_color: :grey, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:grey) },
        v1h4: %BoardSquareForm{ character: v1h4, is_intersection: false, feedback_color: :grey, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:grey) },
        v1h5: %BoardSquareForm{ character: v1h5, is_intersection: false, feedback_color: :green, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:green) },
        v2h1: %BoardSquareForm{ character: v2h1, is_intersection: false, feedback_color: :grey, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:grey) },
        v2h3: %BoardSquareForm{ character: v2h3, is_intersection: false, feedback_color: :grey, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:grey) },
        v2h5: %BoardSquareForm{ character: v2h5, is_intersection: false, feedback_color: :grey, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:grey) },
        v3h1: %BoardSquareForm{ character: v3h1, is_intersection: true, feedback_color: :grey, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:grey) },
        v3h2: %BoardSquareForm{ character: v3h2, is_intersection: false, feedback_color: :grey, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:grey) },
        v3h3: %BoardSquareForm{ character: v3h3, is_intersection: true, feedback_color: :grey, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:grey) },
        v3h4: %BoardSquareForm{ character: v3h4, is_intersection: false, feedback_color: :grey, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:grey) },
        v3h5: %BoardSquareForm{ character: v3h5, is_intersection: true, feedback_color: :grey, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:grey) },
        v4h1: %BoardSquareForm{ character: v4h1, is_intersection: false, feedback_color: :grey, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:grey) },
        v4h3: %BoardSquareForm{ character: v4h3, is_intersection: false, feedback_color: :grey, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:grey) },
        v4h5: %BoardSquareForm{ character: v4h5, is_intersection: false, feedback_color: :grey, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:grey) },
        v5h1: %BoardSquareForm{ character: v5h1, is_intersection: false, feedback_color: :green, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:green) },
        v5h2: %BoardSquareForm{ character: v5h2, is_intersection: false, feedback_color: :grey, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:grey) },
        v5h3: %BoardSquareForm{ character: v5h3, is_intersection: true, feedback_color: :grey, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:grey) },
        v5h4: %BoardSquareForm{ character: v5h4, is_intersection: false, feedback_color: :grey, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:grey) },
        v5h5: %BoardSquareForm{ character: v5h5, is_intersection: false, feedback_color: :green, feedback_color_class: WaffleUtil.color_atom_to_bulma_color_class(:green) }
      }

    end
end
