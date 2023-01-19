defmodule DemoWeb.BoardForm do
  alias DemoWeb.BoardSquareForm
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

end
